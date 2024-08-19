//
//  SaveLinkFeature.swift
//  Features
//
//  Created by 문정호 on 8/11/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
struct SaveLinkFeature {
  @ObservableState
  struct State {
    var urlText = ""
    var presentLoading = false
    var saveButtonActive = false
    var isValidationURL = true
    var validationReasonText = "URL 형식이 올바르지 않아요. 다시 입력해주세요."
  }
    
  enum Action: BindableAction {
    case onTapNextButton
    case onTapBackButton
    
    case binding(BindingAction<State>)
  }
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .onTapBackButton:
        
        return .none
      case .onTapNextButton:
        if state.urlText.containsHTTPorHTTPS {
          state.presentLoading.toggle()
        } else {
          state.isValidationURL = false
        }
        
        return .none
        
      case .binding(\.urlText):
        state.saveButtonActive = !state.urlText.isEmpty
        
        return .none
      case .binding(_):
          return .none
      }
    }
  }
}
