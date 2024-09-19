//
//  StorageBoxFeedListFeature.swift
//  Features
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import CommonFeature
import Services
import Models

import ComposableArchitecture

@Reducer
public struct StorageBoxFeedListFeature {
  @ObservableState
  public struct State: Equatable {
    var folderInput: Folder
    
    var cursor: Int = 0
    var morePagingNeeded: Bool = true
    var fetchedAllFeedCards: Bool = false
    
    var folderFeedList: [FeedCard] = []
    var selectedFeed: FeedCard?
    
    @Presents var calendarContent: CalendarViewFeature.State?
    @Presents var editLink: EditLinkFeature.State?
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    
    var isMenuBottomSheetPresented: Bool = false
    
    public init(folder: Folder) {
      self.folderInput = folder
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onViewDidLoad
    case closeButtonTapped
    case searchBannerSearchBarTapped
    case searchBannerCalendarTapped
    case pagination
    case pullToRefresh
    case cardItemTapped(Int)
    case cardItemSaveButtonTapped(Int, Bool)
    case cardItemMenuButtonTapped(FeedCard)
    case feedDetailWillDisappear(Feed)
    
    // MARK: Inner Business Action
    case resetCursor
    case updateCursor
    case fetchFolderFeeds(folderId: Int, cursor: Int)
    case patchBookmark(Int, Bool)
    case deleteFeed(Int)
    
    // MARK: Inner SetState Action
    case setFeedList([FeedCard])
    case setDeleteFeed(Int)
    case setMorePagingStatus(Bool)
    case setFetchedAllCardsStatus(Bool)
    
    // MARK: Delegate Action
    public enum Delegate {
      case routeSearchKeyword
      case routeFeedDetail(Int)
    }
    
    case delegate(Delegate)
    
    // MARK: Child Action
    case calendarContent(PresentationAction<CalendarViewFeature.Action>)
    case editLink(PresentationAction<EditLinkFeature.Action>)
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    
    // MARK: Navigation Action
    case routeCalendar
    
    // MARK: Present Action
    case editLinkPresented(Int)
  }
  
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.folderClient) private var folderClient
  @Dependency(\.feedClient) private var feedClient
  
  private enum ThrottleId {
    case saveButton
  }
  
  private enum DebounceId {
    case pagination
    case pullToRefresh
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet) {
      EditFolderBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .onViewDidLoad:
        return .send(.fetchFolderFeeds(folderId: state.folderInput.id, cursor: state.cursor))
        
      case .closeButtonTapped:
        return .run { _ in await self.dismiss() }
        
      case .searchBannerSearchBarTapped:
        return .send(.delegate(.routeSearchKeyword))
        
      case .searchBannerCalendarTapped:
        return .send(.routeCalendar)
        
      case .pagination:
        return .send(.updateCursor)
          .debounce(id: DebounceId.pagination, for: .seconds(0.3), scheduler: DispatchQueue.main)
        
      case .pullToRefresh:
        return .run { [state] send in
          await send(.resetCursor)
          await send(.fetchFolderFeeds(folderId: state.folderInput.id, cursor: 0))
        }
        .debounce(id: DebounceId.pagination, for: .seconds(0.3), scheduler: DispatchQueue.main)
        
      case let .cardItemTapped(feedId):
        return .send(.delegate(.routeFeedDetail(feedId)))
        
      case let .cardItemSaveButtonTapped(index, isMarked):
        guard var item = state.folderFeedList[safe: index] else { return .none }
        
        item.isMarked = isMarked
        state.folderFeedList[index] = item
        return .send(.patchBookmark(item.feedId, isMarked))
          .throttle(id: ThrottleId.saveButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let .cardItemMenuButtonTapped(selectedFeed):
        state.selectedFeed = selectedFeed
        state.isMenuBottomSheetPresented = true
        return .none
        
        /// 추후 서버 데이터로 변경하는 로직으로 수정 필요;
        case let .feedDetailWillDisappear(feed):
          guard let index = state.folderFeedList.firstIndex(where: { $0.feedId == feed.feedId }) else {
            return .none
          }
          
          let feedCard = state.folderFeedList[index]
          let updateFeedCard = feed.toFeedCard(feedCard)
          
          if feedCard != updateFeedCard {
            state.folderFeedList[index] = updateFeedCard
          }
          return .none
        
      case .resetCursor:
        state.cursor = 0
        state.morePagingNeeded = true
        state.fetchedAllFeedCards = false
        return .none
        
      case .updateCursor:
        state.cursor += 1
        return .send(.fetchFolderFeeds(folderId: state.folderInput.id, cursor: state.cursor))
        
      case let .fetchFolderFeeds(folderId, cursor):
        return .run(
          operation: { send in
            async let folderFeedListResponse = try folderClient.getFolderFeeds(folderId, cursor)
            
            let folderFeedList = try await folderFeedListResponse
            
            if folderFeedList.count == 0 {
              await send(.setMorePagingStatus(false))
              await send(.setFetchedAllCardsStatus(true))
            }
            
            await send(.setFeedList(folderFeedList), animation: .default)
          },
          catch: { error, send in
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
        
      case let .setFeedList(feedList):
        if state.cursor == 0 {
          state.folderFeedList = feedList
        } else {
          state.folderFeedList.append(contentsOf: feedList)
        }
        return .none
        
      case let .setDeleteFeed(feedId):
        state.folderFeedList.removeAll { $0.feedId == feedId }
        return .none
        
      case let .setMorePagingStatus(isPaging):
        state.morePagingNeeded = isPaging
        return .none
        
      case let .setFetchedAllCardsStatus(isPaging):
        state.fetchedAllFeedCards = isPaging
        return .none
                
      case .editLink(.presented(.delegate(.didUpdateHome))):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        return .run { send in
          try await Task.sleep(for: .seconds(0.7))
          await send(.cardItemTapped(selectedFeed.feedId))
        }
        
        /// 추후 서버 데이터로 변경하는 로직으로 수정 필요;
      case let .editFolderBottomSheet(.delegate(.didUpdateFolder(feedId, folder))):
        guard let index = state.folderFeedList.firstIndex(where: { $0.feedId == feedId }) else {
          return .none
        }
        
        state.folderFeedList[index].folderName = folder.name
        state.folderFeedList[index].folderId = folder.id
        return .none
        
      case .menuBottomSheet(.editLinkItemTapped):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        state.isMenuBottomSheetPresented = false
        return .run { send in
          try? await Task.sleep(for: .seconds(0.1))
          await send(.editLinkPresented(selectedFeed.feedId))
        }
                
      case .menuBottomSheet(.editFolderItemTapped):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        state.isMenuBottomSheetPresented = false
        return .run { send in await send(.editFolderBottomSheet(.editFolderTapped(selectedFeed.feedId, selectedFeed.folderName))) }
        
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
            rightButtonAction: { await send(.deleteFeed(selectedFeed.feedId)) }
          ))
        }
                
      case .routeCalendar:
        state.calendarContent = .init()
        return .none
        
      case let .editLinkPresented(feedId):
        state.editLink = .init(editLinkType: .home(feedId: feedId))
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$calendarContent, action: \.calendarContent) {
      CalendarViewFeature()
    }
    .ifLet(\.$editLink, action: \.editLink) {
      EditLinkFeature()
    }
  }
}
