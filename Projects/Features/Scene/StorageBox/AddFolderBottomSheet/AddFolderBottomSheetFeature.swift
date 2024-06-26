//
//  AddFolderBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

/// 어떤 뷰에서 파일 추가 바텀시트를 활용하고 있는지 체크
public enum AddFolderNavigationType {
  /// 폴더함 메인
  case storageBox
  /// 홈 > 왼쪽 스와이프 액션 > 폴더 수정
  case homeEditFolder
}

@Reducer
public struct AddFolderBottomSheetFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    public var isAddFolderBottomSheetPresented: Bool = false
    public var isHighlight: Bool = true
    public var folderInput: Folder = .init(title: "", count: 0)
    public var savedFolder: Folder?
    public var addFolderNavigationType: AddFolderNavigationType
    
    public init(addFolderNavigationType: AddFolderNavigationType) {
      self.addFolderNavigationType = addFolderNavigationType
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    // MARK: User Action
    case addFolderTapped
    case confirmButtonTapped
    case closeButtonTapped
    
    // MARK: Delegate Action
    public enum Delegate {
      case didUpdateFolderList
    }
    case delegate(Delegate)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.folderInput):
        return .none
        
      case .addFolderTapped:
        state.isAddFolderBottomSheetPresented = true
        return .none
        
      case .confirmButtonTapped:
        state.savedFolder = state.folderInput
        state.isAddFolderBottomSheetPresented = false
        return .send(.delegate(.didUpdateFolderList))
        
      case .closeButtonTapped:
        state.isAddFolderBottomSheetPresented = false
        return .none
        
      default:
        return .none
      }
    }
  }
}
