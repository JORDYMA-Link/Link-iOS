//
//  HomeFeature.swift
//  Blink
//
//  Created by kyuchul on 6/7/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import CommonFeature
import Services
import Models

import ComposableArchitecture

@Reducer
public struct HomeFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    var viewDidLoad: Bool = false
    
    var category: CategoryType = .bookmarked
    /// 저장된 콘텐츠 유무
    var isFeedEmpty: Bool = false
    
    var page: Int = 0
    var morePagingNeeded: Bool = true
    var fetchedAllFeedCards: Bool = false
    
    var feedList: [FeedCard] = []
    var selectedFeed: FeedCard?
    
    @Presents var searchKeyword: SearchKeywordFeature.State?
    @Presents var link: LinkFeature.State?
    @Presents var editLink: EditLinkFeature.State?
    @Presents var settingContent: SettingFeature.State?
    @Presents var calendarContent: CalendarViewFeature.State?
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    
    var isMenuBottomSheetPresented: Bool = false
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onAppear
    case settingButtonTapped
    case instructionBannerTapped
    case searchBannerSearchBarTapped
    case searchBannerCalendarTapped
    case categoryButtonTapped(CategoryType)
    case cardItemTapped(Int)
    case cardItemMenuButtonTapped(FeedCard)
    
    // MARK: Inner Business Action
    case resetPage
    case updatePage
    case fetchFeedList(CategoryType, Int)
    case patchFeed
    case deleteFeed(Int)
    
    // MARK: Inner SetState Action
    case setFeedList([FeedCard])
    case setDeleteFeed(Int)
    case setMorePagingStatus(Bool)
    case setFetchedAllCardsStatus(Bool)
    
    // MARK: Child Action
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case searchKeyword(PresentationAction<SearchKeywordFeature.Action>)
    case link(PresentationAction<LinkFeature.Action>)
    case editLink(PresentationAction<EditLinkFeature.Action>)
    case settingContent(PresentationAction<SettingFeature.Action>)
    case calendarContent(PresentationAction<CalendarViewFeature.Action>)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    
    // MARK: Present Action
  }
  
  @Dependency(\.feedClient) private var feedClient
  @Dependency(\.alertClient) private var alertClient
  
  private enum ThrottleId {
    case categoryButton
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
        
      case .onAppear:
        guard state.viewDidLoad == false else { return .none }
        state.viewDidLoad = true
        return .send(.fetchFeedList(.bookmarked, state.page))
        
      case .settingButtonTapped:
        state.settingContent = .init()
        return .none
        
      case .instructionBannerTapped:
        return .none
        
      case .searchBannerSearchBarTapped:
        state.searchKeyword = .init()
        return .none
        
      case .searchBannerCalendarTapped:
        state.calendarContent = .init()
        return .none
        
      case let .categoryButtonTapped(categoryType):
        if state.category == categoryType {
          return .none
        } else {
          state.category = categoryType
          return .run { [state] send in
              await send(.resetPage)
              await send(.fetchFeedList(state.category, state.page))
          }
          .throttle(id: ThrottleId.categoryButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        }
        
      case let .cardItemTapped(feedId):
        state.link = .init(linkType: .feedDetail(feedId: feedId))
        return .none
        
      case let .cardItemMenuButtonTapped(selectedFeed):
        state.selectedFeed = selectedFeed
        state.isMenuBottomSheetPresented = true
        return .none
        
      case .resetPage:
        state.morePagingNeeded = true
        state.fetchedAllFeedCards = false
        state.page = 0
        return .none
        
      case .updatePage:
        state.page += 1
        return .send(.fetchFeedList(state.category, state.page))
        
      case let .fetchFeedList(categoryType, page):
        return .run(
          operation: { [state] send in
            if state.morePagingNeeded {
              async let feedListResponse = try feedClient.postFeedByType(categoryType.rawValue, page)
              
              let feedList = try await feedListResponse
              
              if feedList.count == 0 {
                await send(.setMorePagingStatus(false))
                await send(.setFetchedAllCardsStatus(true))
              }
              
              await send(.setFeedList(feedList), animation: .default)
            }
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case .patchFeed:
        return .none
        
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
        if state.page == 0 {
          state.feedList = feedList
        } else {
          state.feedList.append(contentsOf: feedList)
        }
        return .none
        
      case let .setDeleteFeed(feedId):
        state.feedList.removeAll { $0.feedId == feedId }
        return .none
        
      case let .setMorePagingStatus(isPaging):
        state.morePagingNeeded = isPaging
        return .none
        
      case let .setFetchedAllCardsStatus(isPaging):
        state.fetchedAllFeedCards = isPaging
        return .none
        
      case let .editFolderBottomSheet(.delegate(.didUpdateFolder(feedId, folder))):
        // patch API 콜 필요
        if let index = state.feedList.firstIndex(where: { $0.feedId == feedId }) {
          state.feedList[index].folderName = folder.name
          state.feedList[index].folderId = folder.id
        }
        
        return .none
        
      case let .link(.presented(.delegate(.didUpdateHome(feed)))):
        print("피드 수정 이후 홈에서 해당 피드 업데이트 처리")
        return .none
        
      case let .editLink(.presented(.delegate(.didUpdateHome(feed)))):
        return .run { send in
          try await Task.sleep(for: .seconds(0.5))
          await send(.cardItemTapped(feed.feedId))
        }
        
        // 홈 -> 수정하기 다이렉트 이동 시 썸네일 정보가 없음 (기획, 백엔드 논의 뒤 수정)
      case .menuBottomSheet(.editLinkItemTapped):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        state.isMenuBottomSheetPresented = false
        state.editLink = .init(editLinkType: .home, feed: Feed.mock())
        return .none
        
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
        
      default:
        return .none
      }
    }
    .ifLet(\.$searchKeyword, action: \.searchKeyword) {
      SearchKeywordFeature()
    }
    .ifLet(\.$link, action: \.link) {
      LinkFeature()
    }
    .ifLet(\.$editLink, action: \.editLink) {
      EditLinkFeature()
    }
    .ifLet(\.$settingContent, action: \.settingContent) {
      SettingFeature()
    }
    .ifLet(\.$calendarContent, action: \.calendarContent) {
      CalendarViewFeature()
    }
  }
}


