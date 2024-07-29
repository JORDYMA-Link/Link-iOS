//
//  StorageBoxFeature.swift
//  Blink
//
//  Created by kyuchul on 5/24/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct StorageBoxFeature: Reducer {
  
  // State를 통해 앱의 상태 변화를 업데이트하는것이 초점이기에 이 앱의 상태들이 변경되면 바인딩된 뷰를 자동으로 업데이트
  // State가 참조 타입이라면 객체 참조가 결국 동일하기에 이를 값의 변화로 보지 않기에 Struct 타입이 적절
  // 상태는 중복되지 않고 각 고유하기에 이 상태의 변화를 비교하기 위해 Equatable을 따라야함
  @ObservableState
  public struct State: Equatable {
    var menuBottomSheet: StorageBoxMenuBottomSheetFeature.State = .init()
    var editFolderNameBottomSheet: EditFolderNameBottomSheetFeature.State = .init()
    var addFolderBottomSheet: AddFolderBottomSheetFeature.State = .init()
        
    var isDeleteFolderPresented: Bool = false
    var deleteFolder: Folder?
    
    @Presents var storageBoxContentList: StorageBoxContentListFeature.State?
    @Presents var searchKeyword: SearchKeywordFeature.State?
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    // MARK: User Action
    case deleteFolderTapped(Folder)
    case deleteFolderModalConfirmTapped
    case deleteFolderModalCancelTapped
    case searchBarTapped
    case folderCellTapped(Folder)
    
    // MARK: Child Action
    case menuBottomSheet(StorageBoxMenuBottomSheetFeature.Action)
    case editFolderNameBottomSheet(EditFolderNameBottomSheetFeature.Action)
    case addFolderBottomSheet(AddFolderBottomSheetFeature.Action)
    case storageBoxContentList(PresentationAction<StorageBoxContentListFeature.Action>)
    case searchKeyword(PresentationAction<SearchKeywordFeature.Action>)
  }
  
  // 리듀서에서는 Action을 기반으로 현재 State를 다음 State로 어떻게 바꿀지 실제적인 구현을 해주는 역할의 프로토콜
  public var body: some ReducerOf<Self> {
    Scope(state: \.menuBottomSheet, action: \.menuBottomSheet) {
      StorageBoxMenuBottomSheetFeature()
    }
    Scope(state: \.editFolderNameBottomSheet, action: \.editFolderNameBottomSheet) {
      EditFolderNameBottomSheetFeature()
    }
    Scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet) {
      AddFolderBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
                
      case let .menuBottomSheet(.menuTapped(type)):
        state.menuBottomSheet.isMenuBottomSheetPresented = false
        guard let folder = state.menuBottomSheet.seletedFolder else { return .none }
        return showEditFolerBottomSheet(type: type, folder: folder)
        
      case let .deleteFolderTapped(folder):
        state.deleteFolder = folder
        state.isDeleteFolderPresented = true
        return .none
        
      case .deleteFolderModalConfirmTapped:
        guard let folder = state.deleteFolder else { return .none }
        return deleteFolder(folder: folder)
        
      case .deleteFolderModalCancelTapped:
        state.deleteFolder = nil
        state.isDeleteFolderPresented = false
        return .none
        
      case .searchBarTapped:
        state.searchKeyword = .init()
        return .none
        
      case let .folderCellTapped(folder):
        state.storageBoxContentList = .init(folderInput: folder)
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
  private func showEditFolerBottomSheet(type: MenuType, folder: Folder) -> Effect<Action> {
        .run { send in
          switch type {
          case .editFolderName:
            try await Task.sleep(for: .seconds(0.1))
            await send(.editFolderNameBottomSheet(.editFolderNameTapped(folder)))
          case .deleteFoler:
            await send(.deleteFolderTapped(folder))
          }
        }
    }
  
  private func deleteFolder(folder: Folder) -> Effect<Action> {
    .run { send in
      print(folder)
    }
  }
}
