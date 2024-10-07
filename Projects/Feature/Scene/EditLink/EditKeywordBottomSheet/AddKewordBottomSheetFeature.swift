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
  public enum KeywordErrorType {
    case textCount
    case keywordCount
  }
  
  @ObservableState
  public struct State: Equatable {
    var keywords: [String] = []
    var text: String = ""
    var isValidation: Bool = true
    
    var isAddKewordBottomSheetPresented: Bool = false
    
    var keywordErrorType: KeywordErrorType = .keywordCount
    var errorMessage: String {
      switch keywordErrorType {
      case .textCount:
        return "키워드는 20자까지 입력 가능해요"
      case .keywordCount:
        return "키워드는 최대 3개까지 지정할 수 있습니다."
      }
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case addKeywordTapped([String])
    case closeButtonTapped
    case textChanged(String)
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
        return .run { send in
          await send(.setValidation)
          await send(.setPresented(true))
        }
        
      case .closeButtonTapped, .confirmButtonTapped:
        state.text = ""
        state.isAddKewordBottomSheetPresented = false
        return .send(.delegate(.updateKeywords(state.keywords)))
        
      case let .textChanged(text):
        state.text = text
        return .send(.setValidation)
        
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
        if state.keywords.count == 3 {
          state.keywordErrorType = .keywordCount
          state.isValidation = false
        } else if state.text.count > 20 {
          state.keywordErrorType = .textCount
          state.isValidation = false
        } else {
          state.isValidation = true
        }
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
