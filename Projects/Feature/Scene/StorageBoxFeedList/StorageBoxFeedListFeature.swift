//
//  StorageBoxFeedListFeature.swift
//  Features
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Analytics
import Services
import Models

import CommonFeature

import ComposableArchitecture

@Reducer
public struct StorageBoxFeedListFeature {
  @ObservableState
  public struct State: Equatable {
    var folderInput: Folder
    
    var selectedFeed: FeedCard?
    var feeds: BKCardFeature.State?
    
    var morePagingNeeded: Bool = true
    
    var emptyTitle: String = "아직 저장된 글이 없어요"
    
    @Presents var calendarContent: CalendarSearchFeature.State?
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
    case pullToRefresh
    case feedDetailWillDisappear(Feed)
    
    // MARK: Inner Business Action
    case fetchFolderFeeds(folderId: Int, cursor: Int)
    case deleteFeed(Int)
    
    // MARK: Inner SetState Action
    case setFeeds([FeedCard])
    case setMorePagingStatus(Bool)
    
    // MARK: Delegate Action
    public enum Delegate {
      case routeSearchKeyword
      case routeFeedDetail(Int)
    }
    
    case delegate(Delegate)
    
    // MARK: Child Action
    case calendarContent(PresentationAction<CalendarSearchFeature.Action>)
    case feeds(BKCardFeature.Action)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    case editLink(PresentationAction<EditLinkFeature.Action>)
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    
    // MARK: Navigation Action
    case routeCalendar
    
    // MARK: Present Action
    case editLinkPresented(Int)
    case editFolderPresented(Int, String)
  }
  
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(\.folderClient) private var folderClient
  @Dependency(\.feedClient) private var feedClient
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.dismiss) private var dismiss
  
  private enum DebounceId {
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
        return .run(
          operation: { [state] send in
            let folderFeedList = try await folderClient.getFolderFeeds(state.folderInput.id, 0)
            
            await send(.setFeeds(folderFeedList))
            await send(.feeds(.setLoading(false)), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case .closeButtonTapped:
        return .run { _ in await self.dismiss() }
        
      case .searchBannerSearchBarTapped:
        searchBarTappedLog()
        
        return .send(.delegate(.routeSearchKeyword))
        
      case .searchBannerCalendarTapped:
        calendarTappedLog()
        
        return .send(.routeCalendar)
        
      case .pullToRefresh:
        return .run { send in
          await send(.setMorePagingStatus(true))
          await send(.feeds(.resetPage))
        }
        .debounce(id: DebounceId.pullToRefresh, for: .seconds(0.3), scheduler: DispatchQueue.main)
        
        /// 추후 서버 데이터로 변경하는 로직으로 수정 필요;
      case let .feedDetailWillDisappear(feed):
        return .send(.feeds(.feedDetailWillDisappear(feed)))
        
      case let .fetchFolderFeeds(folderId, cursor):
        return .run(
          operation: { [state] send in
            if state.morePagingNeeded {
              async let feedListResponse = try folderClient.getFolderFeeds(folderId, cursor)
              
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
        
      case let .setFeeds(feedList):
        state.feeds = .init(feedList: feedList)
        return .none
        
      case let .setMorePagingStatus(isPaging):
        state.morePagingNeeded = isPaging
        return .none
        
      case let .feeds(.cardItemTapped(feedId)):
        cardItemTappedLog(folderId: state.folderInput.id, feedId: feedId)
        
        return .send(.delegate(.routeFeedDetail(feedId)))
        
      case let .feeds(.cardItemMenuButtonTapped(selectedFeed)):
        state.selectedFeed = selectedFeed
        state.isMenuBottomSheetPresented = true
        return .none
        
      case let .feeds(.fetchFeedList(cursor)):
        return .send(.fetchFolderFeeds(folderId: state.folderInput.id, cursor: cursor))
        
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
        
      case .routeCalendar:
        state.calendarContent = .init()
        return .none
        
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
    .ifLet(\.$calendarContent, action: \.calendarContent) {
      CalendarSearchFeature()
    }
    .ifLet(\.$editLink, action: \.editLink) {
      EditLinkFeature()
    }
  }
}

// MARK: Analytics Log

extension StorageBoxFeedListFeature {
  private func searchBarTappedLog() {
    analyticsClient.logEvent(.init(name: .storageboxFeedListSearchFeedClicked, screen: .storagebox_feed_list))
  }
  
  private func calendarTappedLog() {
    analyticsClient.logEvent(.init(name: .storageboxFeedListCalendarClicked, screen: .storagebox_feed_list))
  }
  
  private func cardItemTappedLog(folderId: Int, feedId: Int) {
    analyticsClient.logEvent(.init(name: .storageboxFeedListFeedClicked, screen: .storagebox_feed_list, extraParameters: [.folderId: folderId, .feedId: feedId]))
  }
}
