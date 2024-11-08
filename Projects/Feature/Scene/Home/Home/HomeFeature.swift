//
//  HomeFeature.swift
//  Blink
//
//  Created by kyuchul on 6/7/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import CommonFeature
import Common
import Services
import Models
import Analytics

import ComposableArchitecture

@Reducer
public struct HomeFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    var viewDidLoad: Bool = false
    var category: CategoryType = .bookmarked
    
    var selectedFeed: FeedCard?
    var feeds: BKCardFeature.State?
    
    var morePagingNeeded: Bool = true
    
    var emptyTitle: String {
      switch category {
      case .bookmarked:
        return "북마크된 콘텐츠가 없습니다\n중요한 링크는 북마크하여 바로 확인해보세요"
      case .unclassified:
        return "미분류된 콘텐츠가 없습니다\n분류가 고민일 땐 추천폴더를 받아보세요"
      }
    }
    
    @Presents var editLink: EditLinkFeature.State?
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    var addFolderBottomSheet: AddFolderBottomSheetFeature.State = .init()
    
    var isMenuBottomSheetPresented: Bool = false
    
    var summaryType: SummaryType = .summarizing
    var isSummaryToastPresented = false
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onAppear
    case onViewDidLoad
    case settingButtonTapped
    case searchBannerSearchBarTapped
    case searchBannerCalendarTapped
    case categoryButtonTapped(CategoryType)
    case pullToRefresh
    case feedDetailWillDisappear(Feed)
    case summaryToastRouteButtonTapped
    
    // MARK: Inner Business Action
    case fetchFeedList(CategoryType, Int)
    case deleteFeed(Int)
    case patchFeedFolder(Int, String)
    case fetchLinkProcessing
    
    // MARK: Inner SetState Action
    case setFeeds([FeedCard])
    case setMorePagingStatus(Bool)
    case setSummaryToastPresented(SummaryType, Bool)
    
    // MARK: Delegate Action
    public enum Delegate {
      case routeSetting
      case routeSearchKeyword
      case routeCalendar
      case routeFeedDetail(Int)
      case routeStorageBoxFeedList(Folder)
      case routeSummaryStatusList
    }
    
    case delegate(Delegate)
    
    // MARK: Child Action
    case feeds(BKCardFeature.Action)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    case editLink(PresentationAction<EditLinkFeature.Action>)
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case addFolderBottomSheet(AddFolderBottomSheetFeature.Action)
    
    // MARK: Present Action
    case editLinkPresented(Int)
    case editFolderPresented(Int, String)
  }
  
  @Dependency(\.feedClient) private var feedClient
  @Dependency(\.folderClient) private var folderClient
  @Dependency(\.linkClient) private var linkClient
  @Dependency(\.alertClient) private var alertClient
  @Dependency(AnalyticsClient.self) private var analyticsClient
  
  private enum ThrottleId {
    case categoryButton
  }
  
  private enum DebounceId {
    case pullToRefresh
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet) {
      EditFolderBottomSheetFeature()
    }
    
    Scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet) {
      AddFolderBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .onAppear:
        return .run { send in
          await send(.onViewDidLoad)
          await send(.fetchLinkProcessing)
        }
        
      case .onViewDidLoad:
        guard state.viewDidLoad == false else { return .none }
        state.viewDidLoad = true
        return .run(
          operation: { [state] send in
            let feedList = try await feedClient.postFeedByType(state.category.rawValue, 0)
            
            await send(.setFeeds(feedList))
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case .settingButtonTapped:
        return .send(.delegate(.routeSetting))
        
      case .searchBannerSearchBarTapped:
        return .send(.delegate(.routeSearchKeyword))
        
      case .searchBannerCalendarTapped:
        return .send(.delegate(.routeCalendar))
        
      case let .categoryButtonTapped(categoryType):
        if state.category == categoryType {
          return .none
        } else {
          state.category = categoryType
          return .run { send in
            await send(.feeds(.setCategory(categoryType)))
            await send(.setMorePagingStatus(true))
            await send(.feeds(.resetPage))
          }
          .throttle(id: ThrottleId.categoryButton, for: .seconds(0.3), scheduler: DispatchQueue.main, latest: true)
        }
        
      case .pullToRefresh:
        return .run { send in
          await send(.setMorePagingStatus(true))
          await send(.feeds(.resetPage))
        }
        .debounce(id: DebounceId.pullToRefresh, for: .seconds(0.3), scheduler: DispatchQueue.main)
        
        /// 추후 서버 데이터로 변경하는 로직으로 수정 필요;
      case let .feedDetailWillDisappear(feed):
        return .send(.feeds(.feedDetailWillDisappear(feed)))
        
      case .summaryToastRouteButtonTapped:
        summaryToastRouteButtonTappedLog()
        return .send(.delegate(.routeSummaryStatusList))
        
      case let .fetchFeedList(category, page):
        return .run(
          operation: { [state] send in
            if state.morePagingNeeded {
              async let feedListResponse = try feedClient.postFeedByType(category.rawValue, page)
              
              let feedList = try await feedListResponse
              
              if feedList.count == 0 {
                await send(.setMorePagingStatus(false))
                await send(.feeds(.setFetchedAllCardsStatus(true)))
              }
              
              await send(.feeds(.setAddFeeds(feedList)), animation: .default)
            }
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .deleteFeed(feedId):
        return .run(
          operation: { send in
            _ = try await feedClient.deleteFeed(feedId)
            
            await send(.feeds(.setDeleteFeed(feedId)), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .patchFeedFolder(feedId, name):
        return .run(
          operation: { send in
            let feedFolder = try await folderClient.patchFeedFolder(feedId, name)
            
            await send(.delegate(.routeStorageBoxFeedList(feedFolder)))
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case .fetchLinkProcessing:
        return .run(
          operation: { send in
            async let linkProcessingResponse = try linkClient.getLinkProcessing()
            
            let linkProcessing = try await linkProcessingResponse.processingList
            
            guard !linkProcessing.isEmpty else {
              await send(.setSummaryToastPresented(.summarizing, false))
              return
            }
            
            if linkProcessing.contains(where: { $0.status == .requested || $0.status == .processing }) {
              await send(.setSummaryToastPresented(.summarizing, true))
            } else {
              await send(.setSummaryToastPresented(.summaryComplete, true))
            }
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .setFeeds(feedList):
        state.feeds = .init(feedList: feedList)
        return .none
        
      case let .setMorePagingStatus(isPaging):
        state.morePagingNeeded = isPaging
        return .none
        
      case let .setSummaryToastPresented(type, isPresented):
        state.summaryType = type
        state.isSummaryToastPresented = isPresented
        return .none
        
      case let .feeds(.cardItemTapped(feedId)):
        return .send(.delegate(.routeFeedDetail(feedId)))
        
      case let .feeds(.cardItemMenuButtonTapped(selectedFeed)):
        state.selectedFeed = selectedFeed
        state.isMenuBottomSheetPresented = true
        return .none
        
      case let .feeds(.cardItemRecommendedFolderTapped(feedId, folderName)):
        return .send(.patchFeedFolder(feedId, folderName))
        
      case let .feeds(.cardItemAddFolderTapped(selectedFeed)):
        state.selectedFeed = selectedFeed
        return .send(.addFolderBottomSheet(.addFolderTapped))
        
      case let .feeds(.fetchFeedList(page)):
        return .send(.fetchFeedList(state.category, page))
        
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
        return .run { send in
          try? await Task.sleep(for: .seconds(0.5))
          await send(.editFolderPresented(selectedFeed.feedId, selectedFeed.folderName))
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
            rightButtonAction: { await send(.deleteFeed(selectedFeed.feedId)) }
          ))
        }
        
      case let .editLink(.presented(.delegate(.didUpdateHome(feed)))):
        return .run { send in
          try await Task.sleep(for: .seconds(0.5))
          await send(.feeds(.cardItemTapped(feed.feedId)))
        }
        
        /// 추후 서버 데이터로 변경하는 로직으로 수정 필요;
      case let .editFolderBottomSheet(.delegate(.didUpdateFolder(feedId, folder))):
        return .send(.feeds(.setFeedFolder(feedId, folder)))
        
      case let .addFolderBottomSheet(.delegate(.didUpdate(folder))):
        guard let selectedFeed = state.selectedFeed else { return .none }
        return .run { send in
          try? await Task.sleep(for: .seconds(0.5))
          await send(.patchFeedFolder(selectedFeed.feedId, folder.name))
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
    .ifLet(\.feeds, action: \.feeds) {
      BKCardFeature()
    }
    .ifLet(\.$editLink, action: \.editLink) {
      EditLinkFeature()
    }
  }
}

// MARK: Analytics Log

extension HomeFeature {
  private func summaryToastRouteButtonTappedLog() {
    analyticsClient.logEvent(event: .init(name: .homeSummaringFeedClicked, screen: .home))
  }
}
