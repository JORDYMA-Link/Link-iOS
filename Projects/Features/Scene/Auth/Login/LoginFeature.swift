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
    // MARK: User Action
    case binding(BindingAction<State>)
    case kakaoLoginButtonTapped
    case appleLoginButtonTapped
    
    case _setSocialLoginInfo(SocialLogin)
    
    // MARK: Delegate Action
    public enum Delegate {
      case moveToOnboarding
    }
    
    case delegate(Delegate)
    
    // MARK: Child Action
    case onboardingSubjectFeature(PresentationAction<OnboardingSubjectFeature.Action>)
  }
  
  @Dependency(\.userDefaultsClient) var userDefault
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
          try await requestLogin(info, send: send)
        }
        .throttle(id: ThrottleId.loginButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let ._setSocialLoginInfo(info):
        state.loginInfo = info
        return .none
                
      default:
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
        // 온보딩 플로우 테스트
        userDefault.set(true, .isFirstLogin)
        
        if userDefault.bool(.isFirstLogin, false) {
          await send(.delegate(.moveToOnboarding))
        } else {
          print(info)
        }
      }
    } catch {
      print(error)
    }
  }
}
