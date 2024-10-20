//
//  SearchFeature.swift
//  Blink
//
//  Created by kyuchul on 6/10/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import CommonFeature
import Models
import Services

import ComposableArchitecture

@Reducer
public struct SearchFeature {
  @ObservableState
  public struct State: Equatable {
    struct SelectedFeed: Equatable {
      let sectionIndex: Int
      let index: Int
      let feed: FeedCard
    }
    
    var query: String = ""
    var keyword: String = ""
    var isSearchable: Bool = false
    
    var page: Int = 0
    
    var feedSection: [SearchFeed] = []
    var selectedFeed: SelectedFeed?
    var recentSearches: [String] = []
    
    @Presents var editLink: EditLinkFeature.State?
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    
    var isMenuBottomSheetPresented: Bool = false
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onTask
    case closeButtonTapped
    case searchButtonTapped(String)
    case removeAllRecentSearchButtonTapped
    case removeRecentSearchButtonTapped(String)
    case recentSearchItemTapped(String)
    case keywordSearchItemTapped(sectionIndex: Int, index: Int, feed: FeedCard)
    case keywordSearchItemSaveButtonTapped(sectionIndex: Int, index: Int, isMarked: Bool, feedId: Int)
    case keywordSearchMenuButtonTapped(sectionIndex: Int, index: Int, feed: FeedCard)
    case footerPaginationButtonTapped(Int)
    case feedDetailWillDisappear(Feed)
    
    // MARK: Inner Business Action
    case resetPage
    case updatePage
    case fetchSearchFeedSection(query: String, page: Int)
    case patchBookmark(Int, Bool)
    case deleteFeed(Int)
    
    // MARK: Inner SetState Action
    case setSearchFeedSection(SearchFeed)
    case setDeleteFeed(Int)
    case setSelectedFeed(sectionIndex: Int, index: Int, feed: FeedCard)
    case setRecentSearches(String)
    case setRemoveAllRecentSearches
    case setRemoveRecentSearches(String)
    
    // MARK: Delegate Action
    public enum Delegate {
      case routeFeedDetail(Int)
    }
    
    case delegate(Delegate)
    
    // MARK: Child Action
    case editLink(PresentationAction<EditLinkFeature.Action>)
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
        
    // MARK: Present Action
    case editLinkPresented(Int)
    case editFolderPresented(Int, String)
  }
  
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.userDefaultsClient) private var userDefault
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.feedClient) private var feedClient
  
  private enum ThrottleId {
    case saveButton
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet) {
      EditFolderBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.query):
        if state.query.isEmpty {
          state.isSearchable = false
        }
        return .none
        
      case .onTask:
        state.recentSearches = userDefault.stringArray(.recentSearches, [])
        return .none
        
      case .closeButtonTapped:
        return .run { _ in await self.dismiss() }
        
      case let .searchButtonTapped(query):
        guard !query.isEmpty else { return .none }
        
        return .run { send in
          await send(.setRecentSearches(query))
          await send(.resetPage)
        }
        
      case .removeAllRecentSearchButtonTapped:
        guard !state.recentSearches.isEmpty else { return .none }
        
        return .send(.setRemoveAllRecentSearches)
        
      case let .removeRecentSearchButtonTapped(keyword):
        return .send(.setRemoveRecentSearches(keyword))
        
      case let .recentSearchItemTapped(keyword):
        state.query = keyword
        
        return .run { send in
          await send(.setRecentSearches(keyword))
          await send(.resetPage)
        }
        
      case let .keywordSearchItemTapped(sectionIndex, index, feed):
        return .run { send in
          await send(.setSelectedFeed(sectionIndex: sectionIndex, index: index, feed: feed))
          await send(.delegate(.routeFeedDetail(feed.feedId)))
        }
        
      case let .keywordSearchItemSaveButtonTapped(sectionIndex, index, isMarked, feedId):
        guard var section = state.feedSection[safe: sectionIndex] else {
          return .none
        }
        
        guard section.result.indices.contains(index) else {
          return .none
        }
        
        section.result[index].isMarked = isMarked
        state.feedSection[sectionIndex] = section
        return .send(.patchBookmark(feedId, isMarked))
          .throttle(id: ThrottleId.saveButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let .keywordSearchMenuButtonTapped(sectionIndex, index, feed):
        state.isMenuBottomSheetPresented = true
        return .run { send in
          await send(.setSelectedFeed(sectionIndex: sectionIndex, index: index, feed: feed))
        }
        
        
      case let .footerPaginationButtonTapped(index):
        guard var section = state.feedSection[safe: index] else {
          return .none
        }
                
        section.isPagination = false
        state.feedSection[index] = section
        return .send(.updatePage)
      
      /// 추후 서버 데이터로 변경하는 로직으로 수정 필요;
      case let .feedDetailWillDisappear(feed):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        guard var section = state.feedSection[safe: selectedFeed.sectionIndex],
              let feedCard = section.result[safe: selectedFeed.index] else {
          return .none
        }
        
        let updateFeedCard = feed.toFeedCard(feedCard)
        section.result[selectedFeed.index] = updateFeedCard
        
        if feedCard != updateFeedCard {
          state.feedSection[selectedFeed.sectionIndex] = section
        }
        
        return .none
        
      case .resetPage:
        state.page = 0
        return .send(.fetchSearchFeedSection(query: state.query, page: state.page))
        
      case .updatePage:
        state.page += 1
        return .send(.fetchSearchFeedSection(query: state.keyword, page: state.page))
        
      case let .fetchSearchFeedSection(query, page):
        return .run(
          operation: { send in
            async let feedSectionResponse = try feedClient.getFeedSearch(query, page)
            
            var feedSection = try await feedSectionResponse
            
            if feedSection.result.count < 10 {
              feedSection.isLast = true
            }
            
            await send(.setSearchFeedSection(feedSection), animation: .default)
          },
          catch: { send, error in
            print(error)
          }
        )
        
      case let .patchBookmark(feedId, isMarked):
        return .run(
          operation: { send in
            let feedBookmark = try await feedClient.patchBookmark(feedId, isMarked)
            
            print(feedBookmark)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .deleteFeed(feedId):
        return .run(
          operation: { send in
            _ = try await feedClient.deleteFeed(feedId)
            
            await send(.setDeleteFeed(feedId), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .setSearchFeedSection(feedSection):
        state.isSearchable = true
        state.keyword = feedSection.query
        
        if state.page == 0 && feedSection.result.isEmpty {
          state.feedSection = []
        } else if state.page == 0 {
          state.feedSection = [feedSection]
        } else {
          state.feedSection.append(feedSection)
        }
        return .none
        
      case let .setDeleteFeed(feedId):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        guard var section = state.feedSection[safe: selectedFeed.sectionIndex] else {
          return .none
        }
        
        section.result.removeAll { $0.feedId == feedId }
        
        if section.result.isEmpty {
          state.feedSection.remove(at: selectedFeed.sectionIndex)
        } else {
          state.feedSection[selectedFeed.sectionIndex] = section
        }
        return .none
        
      case let .setSelectedFeed(sectionIndex, index, feed):
        state.selectedFeed = .init(sectionIndex: sectionIndex, index: index, feed: feed)
        return .none
        
      case let .setRecentSearches(query):
        var recentSearches = userDefault.stringArray(.recentSearches, [])
        
        if let index = recentSearches.firstIndex(where: { $0.lowercased() == query.lowercased() }) {
          recentSearches.remove(at: index)
        }
        
        recentSearches.insert(query, at: 0)
        let prefixRecentSearches = recentSearches.prefix(6).map { $0 }
        userDefault.set(prefixRecentSearches, .recentSearches)
        state.recentSearches = prefixRecentSearches
        return .none
        
      case .setRemoveAllRecentSearches:
        let emptyValue: [String] = []
        userDefault.set(emptyValue, .recentSearches)
        
        state.recentSearches = emptyValue
        return .none
        
      case let .setRemoveRecentSearches(keyword):
        var recentSearches = userDefault.stringArray(.recentSearches, [])
        recentSearches.removeAll(where: { $0 == keyword })
        
        userDefault.set(recentSearches, .recentSearches)
        
        state.recentSearches = recentSearches
        return .none
                        
      case .editLink(.presented(.delegate(.didUpdateHome))):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        return .run { send in
          try await Task.sleep(for: .seconds(0.7))
          await send(.keywordSearchItemTapped(sectionIndex: selectedFeed.sectionIndex, index: selectedFeed.index, feed: selectedFeed.feed))
        }
        
        /// 추후 서버 데이터로 변경하는 로직으로 수정 필요;
      case let .editFolderBottomSheet(.delegate(.didUpdateFolder(_, folder))):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        guard var section = state.feedSection[safe: selectedFeed.sectionIndex] else {
          return .none
        }
        
        guard section.result.indices.contains(selectedFeed.index) else {
          return .none
        }
        
        section.result[selectedFeed.index].folderName = folder.name
        section.result[selectedFeed.index].folderId = folder.id
        state.feedSection[selectedFeed.sectionIndex] = section
        return .none
        
      case .menuBottomSheet(.editLinkItemTapped):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        state.isMenuBottomSheetPresented = false
        return .run { send in
          try? await Task.sleep(for: .seconds(0.1))
          
          await send(.editLinkPresented(selectedFeed.feed.feedId))
        }
                
      case .menuBottomSheet(.editFolderItemTapped):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        state.isMenuBottomSheetPresented = false
        return .run { send in
          try? await Task.sleep(for: .seconds(0.5))
          await send(.editFolderPresented(selectedFeed.feed.feedId, selectedFeed.feed.folderName))
        }
        
      case .menuBottomSheet(.deleteLinkItemTapped):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        state.isMenuBottomSheetPresented = false
        return .run { send in
          await alertClient.present(.init(
            title: "삭제",
            description:
            """
            콘텐츠를 삭제하시면 복원이 어렵습니다.
            그래도 삭제하시겠습니까?
            """,
            buttonType: .doubleButton(left: "취소", right: "확인"),
            rightButtonAction: { await send(.deleteFeed(selectedFeed.feed.feedId)) }
          ))
        }
                
      case let .editLinkPresented(feedId):
        state.editLink = .init(editLinkType: .home(feedId: feedId))
        return .none
        
      case let .editFolderPresented(feedId, folderName):
        return .send(.editFolderBottomSheet(.editFolderTapped(feedId, folderName)))
        
      default:
        return .none
      }
    }
    .ifLet(\.$editLink, action: \.editLink) {
      EditLinkFeature()
    }
  }
}
