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
    var loginInfo: SocialLoginInfo?
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    // MARK: User Action
    case binding(BindingAction<State>)
    case kakaoLoginButtonTapped
    case appleLoginButtonTapped
    
    case _setSocialLoginInfo(SocialLoginInfo)
    case _setDestination
    
    // MARK: Delegate Action
    public enum Delegate {
      case moveToOnboarding
      case moveToMainTap
    }
    
    case delegate(Delegate)
    
    // MARK: Child Action
    case onboardingSubjectFeature(PresentationAction<OnboardingSubjectFeature.Action>)
  }
  
  @Dependency(\.userDefaultsClient) var userDefault
  @Dependency(\.keychainClient) var keychainClient
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
        } catch: { error, send in
          print(error)
        }
        .throttle(id: ThrottleId.loginButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case .appleLoginButtonTapped:
        return .run { send in
          let info = try await socialLogin.appleLogin()
          try await requestLogin(info, send: send)
        } catch: { error, send in
          print(error)
        }
        .throttle(id: ThrottleId.loginButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let ._setSocialLoginInfo(info):
        state.loginInfo = info
        return .none
        
      case ._setDestination:
        if userDefault.bool(.isFirstLogin, false) {
          return .send(.delegate(.moveToOnboarding))
        } else {
          return .send(.delegate(.moveToMainTap))
        }
        
      default:
        return .none
      }
    }
  }
}

extension LoginFeature {
  private func requestLogin(_ info: SocialLoginInfo, send: Send<LoginFeature.Action>) async throws {
    do {
      await send(._setSocialLoginInfo(info))
      
      var tokenInfo: TokenInfo?
      
      switch info.provider {
      case .kakao:
        tokenInfo = try await authClient.requestKakaoLogin(.init(idToken: info.idToken, nonce: info.nonce ?? ""))
        
      case .apple:
        tokenInfo = try await authClient.requestAppleLogin(info.idToken)
      }
      
      guard let tokenInfo else { return }
      try await keychainClient.save(.accessToken, tokenInfo.accessToken)
      try await keychainClient.save(.refreshToken, tokenInfo.refreshToken)
      
      await send(._setDestination)
    } catch {
      print(error)
    }
  }
}
