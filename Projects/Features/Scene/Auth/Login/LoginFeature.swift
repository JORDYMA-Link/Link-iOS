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
    
    // MARK: Inner Business Action
    case login(SocialLoginInfo)
    case checkFolderIsEmpty
    case handleDestination(Bool)
    
    // MARK: Inner SetState Action
    case setSocialLoginInfo(SocialLoginInfo)
    
    // MARK: Delegate Action
    public enum Delegate {
      case moveToOnboarding
      case moveToMainTab
    }
    
    case delegate(Delegate)
  }
  
  @Dependency(\.userDefaultsClient) private var userDefault
  @Dependency(\.keychainClient) private var keychainClient
  @Dependency(\.socialLogin) private var socialLogin
  @Dependency(\.authClient) private var authClient
  @Dependency(\.folderClient) private var folderClient
  
  private enum ThrottleId {
    case kakaoLoginButton
    case appleLoginButton
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .kakaoLoginButtonTapped:
        return .run(
          operation: { send in
            let info = try await socialLogin.kakaoLogin()
            await send(.login(info))
          },
          catch: { error, send in
            debugPrint(error)
          }
        )
        .throttle(id: ThrottleId.kakaoLoginButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case .appleLoginButtonTapped:
        return .run(
          operation: { send in
            let info = try await socialLogin.appleLogin()
            await send(.login(info))
          },
          catch: { error, send in
            debugPrint(error)
          }
        )
        .throttle(id: ThrottleId.appleLoginButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let .login(info):
        return .run(
          operation: { send in
            await send(.setSocialLoginInfo(info))
            
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
            
            await send(.checkFolderIsEmpty)
          },
          catch: { error, send in
            debugPrint(error)
          }
        )
        
      case .checkFolderIsEmpty:
        return .run(
          operation: { send in
            let folderList = try await folderClient.getFolders()
            
            await send(.handleDestination(folderList.isEmpty))
          },
          catch: { error, send in
            debugPrint(error)
          }
        )
        
      case let .handleDestination(isFirstLogin):
        if isFirstLogin {
          return .send(.delegate(.moveToOnboarding))
        } else {
          return .send(.delegate(.moveToMainTab))
        }
  
      case let .setSocialLoginInfo(info):
        state.loginInfo = info
        return .none
        
      default:
        return .none
      }
    }
  }
}
