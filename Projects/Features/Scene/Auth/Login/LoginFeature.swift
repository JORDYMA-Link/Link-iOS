//
//  LoginFeature.swift
//  Blink
//
//  Created by kyuchul on 6/7/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Services
import Models

import ComposableArchitecture

@Reducer
public struct LoginFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var loginInfo: SocialLogin?
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case kakaoLoginButtonTapped
    case appleLoginButtonTapped
    
    case _setSocialLoginInfo(SocialLogin)
  }
  
  @Dependency(\.socialLogin) var socialLogin
  @Dependency(\.authClient) var authClient
  
  enum ThrottleId {
    case loginButton
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .kakaoLoginButtonTapped:
        return .run { send in
          let info = try await socialLogin.kakaoLogin()
          try await requestLogin(info, send: send)
        }
        .throttle(id: ThrottleId.loginButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case .appleLoginButtonTapped:
        return .run { send in
          let info = try await socialLogin.appleLogin()
          print(info)
        }
        
      case let ._setSocialLoginInfo(info):
        state.loginInfo = info
        return .none
      }
    }
  }
}

extension LoginFeature {
  private func requestLogin(_ info: SocialLogin, send: Send<LoginFeature.Action>) async throws {
    do {
      await send(._setSocialLoginInfo(info))
      
      switch info.provider {
      case .kakao:
        let login = try await authClient.requestKakaoLogin(.init(idToken: info.authorization, nonce: UUID().uuidString))
        
        print(login)
      case .apple:
        print(info)
      }
    } catch {
      print(error)
    }
  }
}
