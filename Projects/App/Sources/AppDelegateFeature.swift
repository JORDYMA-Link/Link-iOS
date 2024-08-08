//
//  AppDelegateFeature.swift
//  Blink
//
//  Created by kyuchul on 8/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Services

import ComposableArchitecture

@Reducer
struct AppDelegateFeature {  
  @ObservableState
  struct State: Equatable {
    
  }
  
  enum Action {
    case didFinishLaunching
  }
  
  @Dependency(\.socialLogin) var socialLogin
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .didFinishLaunching:
        socialLogin.initKakaoSDK()
        return .none
      }
    }
  }
}
