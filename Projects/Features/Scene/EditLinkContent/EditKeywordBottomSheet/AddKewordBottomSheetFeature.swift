//
//  AddKewordBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 8/18/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct AddKewordBottomSheetFeature {
  @ObservableState
  public struct State: Equatable {
    var keywords: [String] = []
    var text: String = ""
    var isValidation: Bool = false
    
    var isAddKewordBottomSheetPresented: Bool = false
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case addKeywordTapped([String])
    case closeButtonTapped
    case textFieldSubmitButtonTapped
    case chipItemDeleteButtonTapped(String)
    case confirmButtonTapped
    
    // MARK: Inner SetState Action
    case setValidation
    case setPresented(Bool)
    
    // MARK: Delegate Action
    public enum Delegate {
      case updateKeywords([String])
    }
    case delegate(Delegate)
  }
    
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.text):
        return .none
        
      case let .addKeywordTapped(keywords):
        state.keywords = keywords
        state.isValidation = state.keywords.count <= 2
        return .run { send in await send(.setPresented(true)) }
        
      case .closeButtonTapped, .confirmButtonTapped:
        state.text = ""
        state.isAddKewordBottomSheetPresented = false
        return .send(.delegate(.updateKeywords(state.keywords)))
        
      case .textFieldSubmitButtonTapped:
        guard state.isValidation else { return .none }
        
        state.keywords.append(state.text)
        state.text = ""
        return .run { send in await send(.setValidation) }
        
      case let .chipItemDeleteButtonTapped(keyword):
        if let index = state.keywords.firstIndex(where: { $0 == keyword }) {
          state.keywords.remove(at: index)
        }
        
        return .run { send in await send(.setValidation) }
                
      case .setValidation:
        state.isValidation = state.keywords.count <= 2
        return .none
        
      case let.setPresented(isPresented):
        state.isAddKewordBottomSheetPresented = isPresented
        return .none
        
      default:
        return .none
      }
    }
  }
}
