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
  
  public enum Action: BindableAction {
    // MARK: User Action
    case binding(BindingAction<State>)
    case kakaoLoginButtonTapped
    case appleLoginButtonTapped
    
    // MARK: Inner Business Action
    case login(SocialLoginInfo)
    case fetchFolderList
    case putFcmPushToken
    
    // MARK: Inner SetState Action
    case setSocialLoginInfo(SocialLoginInfo)
    case setSaveKeychain(TokenInfo)
    
    // MARK: Delegate Action
    public enum Delegate {
      case moveToOnboarding
      case moveToMainTab
    }
    
    case delegate(Delegate)
  }
  
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.keychainClient) private var keychainClient
  @Dependency(\.socialLogin) private var socialLogin
  @Dependency(\.authClient) private var authClient
  @Dependency(\.userClient) private var userClient
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
            
            await send(.setSaveKeychain(tokenInfo))
          },
          catch: { error, send in
            debugPrint(error)
          }
        )
        
      case .fetchFolderList:
        return .run(
          operation: { send in
            async let folderListResponse = try folderClient.getFolders()
            
            let folderList = try await folderListResponse
            
            if folderList.isEmpty {
              await send(.delegate(.moveToOnboarding))
            } else {
              await send(.delegate(.moveToMainTab))
            }
          },
          catch: { error, send in
            debugPrint(error)
          }
        )
        
      case .putFcmPushToken:
        return .run(
          operation: { send in
            guard !userDefaultsClient.string(.fcmToken, "").isEmpty else {
              return
            }
            
            try await userClient.putFcmPushToken(userDefaultsClient.string(.fcmToken, ""))
          },
          catch: { error, send in
            debugPrint(error)
          }
        )
          
      case let .setSocialLoginInfo(info):
        state.loginInfo = info
        return .none
        
      case let .setSaveKeychain(token):
        return .run { send in
          try await keychainClient.save(.accessToken, token.accessToken)
          try await keychainClient.save(.refreshToken, token.refreshToken)
          
          await send(.putFcmPushToken)
          /// 폴더 유무로 첫 가입 유저 확인
          await send(.fetchFolderList)
        }
        
      default:
        return .none
      }
    }
  }
}
