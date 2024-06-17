//
//  LoginFeature.swift
//  Blink
//
//  Created by kyuchul on 6/7/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Services

import ComposableArchitecture

@Reducer
public struct LoginFeature: Reducer {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case kakaoLoginButtonTapped
  }
  
  @Dependency(\.socialLogin) var socialLogin
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .kakaoLoginButtonTapped:
        return .run { send in
          let info = try await socialLogin.kakaoLogin()
          print(info)
        }
      }
    }
  }
}
