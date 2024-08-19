//
//  HomeFeature.swift
//  Blink
//
//  Created by kyuchul on 6/7/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import CommonFeature
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
    @Presents var linkContent: LinkContentFeature.State?
    @Presents var editLinkContent: EditLinkContentFeature.State?
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
    case linkContent(PresentationAction<LinkContentFeature.Action>)
    case editLinkContent(PresentationAction<EditLinkContentFeature.Action>)
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
        state.linkContent = .init(linkCotentType: .contentDetail)
        return .none
        
      case let .cellMenuButtonTapped(selectedItem):
        state.selectedcellMenuItem = selectedItem
        return .run { send in await send(.menuBottomSheetPresented(true)) }
        
      case let .menuBottomSheetPresented(isPresented):
        state.isMenuBottomSheetPresented = isPresented
        return .none
        
      case .menuBottomSheet(.editLinkContentCellTapped):
        guard let selectedItem = state.selectedcellMenuItem else { return .none }
        
        state.isMenuBottomSheetPresented = false
        state.editLinkContent = .init(link: selectedItem)
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
    .ifLet(\.$linkContent, action: \.linkContent) {
      LinkContentFeature()
    }
    .ifLet(\.$editLinkContent, action: \.editLinkContent) {
      EditLinkContentFeature()
    }
    .ifLet(\.$settingContent, action: \.settingContent) {
      SettingFeature()
    }
    .ifLet(\.$calendarContent, action: \.calendarContent) {
      CalendarViewFeature()
    }
  }
}


