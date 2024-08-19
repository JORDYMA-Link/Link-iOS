//
//  EditMemoBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 7/11/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct EditMemoBottomSheetFeature {
  @ObservableState
  public struct State: Equatable {
    var memo = ""
    var isValidation: Bool = true
    
    var isEditMemoBottomSheetPresented: Bool = false
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case editMemoTapped(String)
    case confirmButtonTapped
    case closeButtonTapped
    
    // MARK: Inner SetState Action
    case setValidation(Bool)
    
    // MARK: Delegate Action
    public enum Delegate {
      case didUpdateMemo(String)
    }
    case delegate(Delegate)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.memo):
        guard state.memo.count <= 1000 else { return .send(.setValidation(false)) }
        return .send(.setValidation(true))
        
      case let .editMemoTapped(memo):
        state.memo = memo
        state.isEditMemoBottomSheetPresented = true
        return .none
        
      case .confirmButtonTapped:
        state.isEditMemoBottomSheetPresented = false
        return .send(.delegate(.didUpdateMemo(state.memo)))
        
      case .closeButtonTapped:
        state.memo = .init()
        state.isEditMemoBottomSheetPresented = false
        return .none
        
      case let .setValidation(isValidation):
        state.isValidation = isValidation
        return .none
                
      default:
        return .none
      }
    }
  }
}
