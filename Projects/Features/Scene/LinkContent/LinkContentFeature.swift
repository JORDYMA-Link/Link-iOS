//
//  LinkContentFeature.swift
//  Features
//
//  Created by kyuchul on 7/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Services
import Models

import ComposableArchitecture

@Reducer
public struct LinkContentFeature {
  @ObservableState
  public struct State: Equatable {
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    var editMemoBottomSheet: EditMemoBottomSheetFeature.State = .init()
    
    var memo = "두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력"
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case closeButtonTapped
    case editButtonTapped
    case editFolderButtonTapped
    case editMemoButtonTapeed
    
    // MARK: Inner Business Action
    
    // MARK: Inner SetState Action
    
    // MARK: Child Action
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case editMemoBottomSheet(EditMemoBottomSheetFeature.Action)
  }
  
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet) {
      EditFolderBottomSheetFeature()
    }
    
    Scope(state: \.editMemoBottomSheet, action: \.editMemoBottomSheet) {
      EditMemoBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .closeButtonTapped:
         return .run { _ in await self.dismiss() }
        
      case .editFolderButtonTapped:
        return .send(.editFolderBottomSheet(.editFolderTapped("test")))
        
      case .editMemoButtonTapeed:
        return .send(.editMemoBottomSheet(.editMemoTapped(state.memo)))
        
      case let .editMemoBottomSheet(.delegate(.didUpdateMemo(memo))):
        state.memo = memo
        return .none
        
      default:
        return .none
      }
    }
  }
}
