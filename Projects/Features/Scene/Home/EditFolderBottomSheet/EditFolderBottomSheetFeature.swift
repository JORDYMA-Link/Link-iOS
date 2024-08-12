//
//  EditFolderBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 6/23/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct EditFolderBottomSheetFeature {
  @ObservableState
  public struct State: Equatable {
    public var addFolderBottomSheet: AddFolderBottomSheetFeature.State = .init()
    
    public var isEditFolderBottomSheetPresented: Bool = false
    
    public var postLinkId: String?
    
    public var folderList: [Folder] = []
    public var seletedFolder: Folder?
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case editFolderTapped(String)
    case folderCellTapped(Folder)
    case closeButtonTapped
    
    // MARK: Child Action
    case addFolderBottomSheet(AddFolderBottomSheetFeature.Action)
    
    // MARK: Inner Business Action
    case _onTask
    
    // MARK: Inner SetState Action
    case _setFolderList([Folder])
    case _selectedFolder(Folder)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet) {
      AddFolderBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case let .editFolderTapped(id):
        state.postLinkId = id
        state.isEditFolderBottomSheetPresented = true
        return .none
        
      case let .folderCellTapped(folder):
        // 해당 폴더로 API 통신
        print(folder)
        state.isEditFolderBottomSheetPresented = false
        return .none
        
      case .closeButtonTapped:
        state.isEditFolderBottomSheetPresented = false
        return .none
        
      case ._onTask:
        guard let id = state.postLinkId else { return .none }
        return requestFolderList(postLinkId: id)
        
      case let ._setFolderList(folderList):
        state.folderList = folderList
        return .none
        
      case let ._selectedFolder(folder):
        state.seletedFolder = folder
        return .none
        
      case .addFolderBottomSheet(.delegate(.fetchFolderList)):
        print("폴더 추가 완료하여 Get 폴더 리스트 API 콜")
        return .none
        
      default:
        return .none
      }
    }
  }
}

extension EditFolderBottomSheetFeature {
  /// 폴더 리스트 API 콜
  private func requestFolderList(postLinkId: String) -> Effect<Action> {
    .run { send in
      do {
        // API 연결 이전 테스트 -> postLinkId로 API 콜하는 상상 로직..
        let dummyFolderList = [
          Folder(id: 14125, name: "코코", feedCount: 214)
          ]
        await send(._setFolderList(dummyFolderList))
        
        if let firstFolder = dummyFolderList.first {
          await send(._selectedFolder(firstFolder))
        }
      } catch {
        print(error)
      }
    }
  }
}
