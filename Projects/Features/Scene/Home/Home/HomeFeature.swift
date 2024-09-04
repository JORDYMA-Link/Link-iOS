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

import ComposableArchitecture

@Reducer
public struct HomeFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    var viewDidLoad: Bool = false
    
    var category: CategoryType = .bookmarked
    
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
    @Presents var storageBoxFeedList: StorageBoxContentListFeature.State?
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    var addFolderBottomSheet: AddFolderBottomSheetFeature.State = .init()
    
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
    case pagination
    case cardItemTapped(Int)
    case cardItemSaveButtonTapped(Int, Bool)
    case cardItemMenuButtonTapped(FeedCard)
    case cardItemRecommendedFolderTapped(String)
    case cardItemAddFolderTapped
    
    // MARK: Inner Business Action
    case resetPage
    case updatePage
    case fetchFeedList(CategoryType, Int)
    case patchBookmark(Int, Bool)
    case deleteFeed(Int)
    case postFolder(String)
    case fetchFolderList(String)
    
    // MARK: Inner SetState Action
    case setFeedList([FeedCard])
    case setDeleteFeed(Int)
    case setMorePagingStatus(Bool)
    case setFetchedAllCardsStatus(Bool)
    
    // MARK: Child Action
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case addFolderBottomSheet(AddFolderBottomSheetFeature.Action)
    case searchKeyword(PresentationAction<SearchKeywordFeature.Action>)
    case link(PresentationAction<LinkFeature.Action>)
    case editLink(PresentationAction<EditLinkFeature.Action>)
    case settingContent(PresentationAction<SettingFeature.Action>)
    case calendarContent(PresentationAction<CalendarViewFeature.Action>)
    case storageBoxFeedList(PresentationAction<StorageBoxContentListFeature.Action>)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    
    // MARK: Navigation Action
    case routeSetting
    case routeInstruction
    case routeSearchKeyword
    case routeCalendar
    case routeFeedDetail(Int)
    case routeStorageBoxFeedList(Folder)
    
    // MARK: Present Action
  }
  
  @Dependency(\.feedClient) private var feedClient
  @Dependency(\.folderClient) private var folderClient
  @Dependency(\.alertClient) private var alertClient
  
  private enum ThrottleId {
    case categoryButton
    case saveButton
  }
  
  private enum DebounceId {
    case pagination
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
        guard state.viewDidLoad == false else { return .none }
        state.viewDidLoad = true
        return .send(.fetchFeedList(.bookmarked, state.page))
        
      case .settingButtonTapped:
        return .send(.routeSetting)
        
      case .instructionBannerTapped:
        return .send(.routeInstruction)
        
      case .searchBannerSearchBarTapped:
        return .send(.routeSearchKeyword)
        
      case .searchBannerCalendarTapped:
        return .send(.routeCalendar)
        
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
        
      case .pagination:
        return .send(.updatePage)
          .debounce(id: DebounceId.pagination, for: .seconds(0.3), scheduler: DispatchQueue.main)
        
      case let .cardItemTapped(feedId):
        return .send(.routeFeedDetail(feedId))
        
      case let .cardItemSaveButtonTapped(index, isMarked):
        guard var item = state.feedList[safe: index] else { return .none }
        
        item.isMarked = isMarked
        state.feedList[index] = item
        return .send(.patchBookmark(item.feedId, isMarked))
          .throttle(id: ThrottleId.saveButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let .cardItemMenuButtonTapped(selectedFeed):
        state.selectedFeed = selectedFeed
        state.isMenuBottomSheetPresented = true
        return .none
        
      case let .cardItemRecommendedFolderTapped(folderName):
        /// addFolder 시 이미 존재하는 에러 발생 -> 해당 폴더의 폴더 리스트로이동
        /// add Folder 성공 시 -> 폴더 생성 후 해당 폴더의 피드 리스트 이동
        return .send(.postFolder(folderName))
        
      case .cardItemAddFolderTapped:
        return .send(.addFolderBottomSheet(.addFolderTapped))
        
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
        
      case let .postFolder(folderName):
        return .run(
          operation: { send in
            let addFolder = try await folderClient.postFolder(folderName)
            
            await send(.routeStorageBoxFeedList(addFolder))
          },
          catch: { error, send in
            /// 이미 존재하는 폴더 에러 분기 처리 필요
            await send(.fetchFolderList(folderName))
          }
        )
        
      case let .fetchFolderList(folderName):
        return .run(
          operation: { send in
            async let folderList = try folderClient.getFolders()
            
            guard let recommendedFolder = try await folderList.filter({ $0.name == folderName }).first else { return }
            
            await send(.routeStorageBoxFeedList(recommendedFolder))
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
        
        /// 추후 서버 데이터로 변경하는 로직으로 수정 필요;
      case let .editFolderBottomSheet(.delegate(.didUpdateFolder(feedId, folder))):
        guard let index = state.feedList.firstIndex(where: { $0.feedId == feedId }) else {
          return .none
        }
        
        state.feedList[index].folderName = folder.name
        state.feedList[index].folderId = folder.id
        return .none
        
      case let .addFolderBottomSheet(.delegate(.didUpdate(folder))):
        return .run { send in
          try await Task.sleep(for: .seconds(0.5))
          await send(.routeStorageBoxFeedList(folder))
        }
        
        /// 추후 서버 데이터로 변경하는 로직으로 수정 필요;
      case let .link(.presented(.delegate(.updateFeed(feed)))):
        guard let index = state.feedList.firstIndex(where: { $0.feedId == feed.feedId }) else {
          return .none
        }
        
        let feedCard = state.feedList[index]
        let updateFeedCard = feed.toFeedCard(feedCard)
        
        if feedCard != updateFeedCard {
          state.feedList[index] = updateFeedCard
        }
        return .none
        
        /// 추후 서버 데이터로 변경하는 로직으로 수정 필요;
      case let .link(.presented(.delegate(.deleteFeed(feed)))):
        return .send(.setDeleteFeed(feed.feedId))
        
      case let .editLink(.presented(.delegate(.didUpdateHome(feed)))):
        return .run { send in
          try await Task.sleep(for: .seconds(0.7))
          await send(.cardItemTapped(feed.feedId))
        }
        
      case .menuBottomSheet(.editLinkItemTapped):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        state.isMenuBottomSheetPresented = false
        state.editLink = .init(editLinkType: .home(feedId: selectedFeed.feedId))
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
      case .routeSetting:
        state.settingContent = .init()
        return .none
        
      case .routeInstruction:
        return .none
        
      case .routeSearchKeyword:
        state.searchKeyword = .init()
        return .none
        
      case .routeCalendar:
        state.calendarContent = .init()
        return .none
        
      case let .routeFeedDetail(feedId):
        state.link = .init(linkType: .feedDetail(feedId: feedId))
        return .none
        
      case let .routeStorageBoxFeedList(folder):
        state.storageBoxFeedList = .init(folderInput: folder)
        return .none
        
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
    .ifLet(\.$storageBoxFeedList, action: \.storageBoxFeedList) {
      StorageBoxContentListFeature()
    }
  }
}
