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
    var selectedcellMenuItem: LinkCard?
    var category: CategoryType = .bookmarked
    
    @Presents var searchKeyword: SearchKeywordFeature.State?
    @Presents var link: LinkFeature.State?
    @Presents var editLink: EditLinkFeature.State?
    @Presents var settingContent: SettingFeature.State?
    @Presents var calendarContent: CalendarViewFeature.State?
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
  
    var isMenuBottomSheetPresented: Bool = false
//    var pushSetting: Bool = false
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onAppear
    case searchBarTapped
    case categoryButtonTapped(CategoryType)
    case calendarSearchTapped
    case settingTapped
    case cellTapped
    case cellMenuButtonTapped(LinkCard)
    
    // MARK: Child Action
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case searchKeyword(PresentationAction<SearchKeywordFeature.Action>)
    case link(PresentationAction<LinkFeature.Action>)
    case editLink(PresentationAction<EditLinkFeature.Action>)
    case settingContent(PresentationAction<SettingFeature.Action>)
    case calendarContent(PresentationAction<CalendarViewFeature.Action>)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    
    // MARK: Inner Business Action
    case menuBottomSheetPresented(Bool)
    
    // MARK: Inner SetState Action
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
        return .none

      case .searchBarTapped:
        state.searchKeyword = .init()
        return .none
        
      case let .categoryButtonTapped(categoryType):
        if state.category == categoryType {
          return .none
        } else {
          state.category = categoryType
          return .none
        }

      case .calendarSearchTapped:
        state.calendarContent = .init()
        return .none
        
      case .settingTapped:
        state.settingContent = .init()
        return .none
        
      case .cellTapped:
        state.link = .init(linkType: .feedDetail(feedId: 2))
        return .none
        
      case let .cellMenuButtonTapped(selectedItem):
        state.selectedcellMenuItem = selectedItem
        return .run { send in await send(.menuBottomSheetPresented(true)) }
        
      case let .editLink(.presented(.delegate(.didUpdateHome(feed)))):
        print("피드 수정 이후 홈에서 해당 피드 업데이트 처리")
        return .none
        
      case let .menuBottomSheetPresented(isPresented):
        state.isMenuBottomSheetPresented = isPresented
        return .none
        
      case .menuBottomSheet(.editLinkContentCellTapped):
        guard let selectedItem = state.selectedcellMenuItem else { return .none }
        
        state.isMenuBottomSheetPresented = false
        state.editLink = .init(editLinkType: .home, feed: Feed.mock())
        return .none
        
      case .menuBottomSheet(.editFolderCellTapped):
        guard let selectedItem = state.selectedcellMenuItem else { return .none }
        
        state.isMenuBottomSheetPresented = false
        return .run { send in await send(.editFolderBottomSheet(.editFolderTapped(String(selectedItem.id)))) }
        
      case .menuBottomSheet(.deleteLinkContentCellTapped):
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


