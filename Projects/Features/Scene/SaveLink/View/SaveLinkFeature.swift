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
    //MARK: - Action
    case presentModal
    
    //MARK: UserAction
    case onTapNextButton
    case onTapBackButton
    case onTapBackToMain
    
    case binding(BindingAction<State>)
  }
  
  @Dependency(\.linkClient) private var linkClient
  
  var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .onTapBackButton:
        break
        
      case .onTapNextButton:
        guard state.urlText.containsHTTPorHTTPS else { return .none }
        
        return .run { [targetURL = state.urlText] send in
          await send(.presentModal)
          guard let _ = try? await linkClient.postLinkSummary(targetURL, "") else { return } //혹시 에러 발생시 대응이 필요할수도 있을지도 모르니
        }
        
      case .onTapBackToMain:
        state.presentLoading.toggle()
        return .none
        
        
      case .presentModal:
        if state.urlText.containsHTTPorHTTPS {
          state.presentLoading.toggle()
        } else {
          state.isValidationURL = false
        }
        
      case .binding(\.urlText):
        state.saveButtonActive = !state.urlText.isEmpty
        
      case .binding:
        break
      }
      return .none
    }
  }
}
