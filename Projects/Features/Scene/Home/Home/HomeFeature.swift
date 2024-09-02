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
    case fetchFeedList(CategoryType)
    
    // MARK: Inner SetState Action
    case setFeedList([FeedCard])
    
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
        return .send(.fetchFeedList(.bookmarked))
                
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
          return .send(.fetchFeedList(categoryType))
            .throttle(id: ThrottleId.categoryButton, for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
        }
        
      case let .cardItemTapped(feedId):
        state.link = .init(linkType: .feedDetail(feedId: feedId))
        return .none
        
      case let .cardItemMenuButtonTapped(selectedFeed):
        state.selectedFeed = selectedFeed
        state.isMenuBottomSheetPresented = true
        return .none
        
      case let .fetchFeedList(categoryType):
        return .run(
          operation: { send in
            let feedList = try await feedClient.postFeedByType(categoryType.rawValue, 0)
            
            await send(.setFeedList(feedList), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .setFeedList(feedList):
        state.feedList = feedList
        return .none
        
        
      case let .editFolderBottomSheet(.delegate(.didUpdateFolder(feedId, folder))):
        if let index = state.feedList.firstIndex(where: { $0.feedId == feedId }) {
          state.feedList[index].folderName = folder.name
          state.feedList[index].folderId = folder.id
        }
        
        return .none

      case let .editLink(.presented(.delegate(.didUpdateHome(feed)))), 
        let .link(.presented(.delegate(.didUpdateHome(feed)))):
        print("피드 수정 이후 홈에서 해당 피드 업데이트 처리")
        return .none
                
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
        print("deleteModal")
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
  }
}


