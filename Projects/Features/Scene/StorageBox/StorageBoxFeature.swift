//
//  StorageBoxFeature.swift
//  Blink
//
//  Created by kyuchul on 5/24/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import CommonFeature
import Models

import ComposableArchitecture

@Reducer
public struct StorageBoxFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    var editFolderNameBottomSheet: EditFolderNameBottomSheetFeature.State = .init()
    var addFolderBottomSheet: AddFolderBottomSheetFeature.State = .init()
    
    var selectedcellMenuItem: Folder?
    var isMenuBottomSheetPresented: Bool = false
    var isDeleteFolderPresented: Bool = false
    
    @Presents var storageBoxContentList: StorageBoxContentListFeature.State?
    @Presents var searchKeyword: SearchKeywordFeature.State?
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    // MARK: User Action
    case searchBarTapped
    case folderCellTapped(Folder)
    case cellMenuButtonTapped(Folder)
    case deleteFolderModalConfirmTapped
    case deleteFolderModalCancelTapped
    
    // MARK: Child Action
    case editFolderNameBottomSheet(EditFolderNameBottomSheetFeature.Action)
    case addFolderBottomSheet(AddFolderBottomSheetFeature.Action)
    case storageBoxContentList(PresentationAction<StorageBoxContentListFeature.Action>)
    case searchKeyword(PresentationAction<SearchKeywordFeature.Action>)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    
    // MARK: Inner Business Action
    case menuBottomSheetPresented(Bool)
    case deleteFolderModalPresented(Bool)
    
    // MARK: Inner SetState Action
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet) {
      AddFolderBottomSheetFeature()
    }
    Scope(state: \.editFolderNameBottomSheet, action: \.editFolderNameBottomSheet) {
      EditFolderNameBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .searchBarTapped:
        state.searchKeyword = .init()
        return .none
        
      case let .folderCellTapped(folder):
        state.storageBoxContentList = .init(folderInput: folder)
        return .none
        
      case let .cellMenuButtonTapped(folder):
        state.selectedcellMenuItem = folder
        return .run { send in await send(.menuBottomSheetPresented(true)) }
        
      case .deleteFolderModalConfirmTapped:
        guard let folder = state.selectedcellMenuItem else { return .none }
        return deleteFolder(folder: folder)
        
      case .deleteFolderModalCancelTapped:
        state.isDeleteFolderPresented = false
        return .none
                        
      case .menuBottomSheet(.editFolderNameCellTapped):
        guard let folder = state.selectedcellMenuItem else { return .none }
        state.isMenuBottomSheetPresented = false
        return .run { send in await send(.editFolderNameBottomSheet(.editFolderNameTapped(folder))) }
                
      case .menuBottomSheet(.deleteFolderCellTapped):
        guard let folder = state.selectedcellMenuItem else { return .none }
        
        state.isMenuBottomSheetPresented = false
        return .run { send in await send(.deleteFolderModalPresented(true)) }
        
      case let .menuBottomSheetPresented(isPresented):
        state.isMenuBottomSheetPresented = isPresented
        return .none
        
      case let .deleteFolderModalPresented(isPresented):
        state.isDeleteFolderPresented = isPresented
        return .none
                
      default:
        return .none
      }
    }
    .ifLet(\.$storageBoxContentList, action: \.storageBoxContentList) {
      StorageBoxContentListFeature()
    }
    .ifLet(\.$searchKeyword, action: \.searchKeyword) {
      SearchKeywordFeature()
    }
  }
}

extension StorageBoxFeature {
  private func deleteFolder(folder: Folder) -> Effect<Action> {
    .run { send in
      print(folder)
    }
  }
}
