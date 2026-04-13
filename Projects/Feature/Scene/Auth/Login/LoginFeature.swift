//
//  LoginFeature.swift
//  Blink
//
//  Created by kyuchul on 6/7/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import AnalyticsClient
import AuthClient
import BKModel
import FolderClient
import Services
import SocialLoginClient
import AlertClient
import UserClient

import ComposableArchitecture

@Reducer
public struct LoginFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var loginInfo: SocialLoginInfo?
    var isLoading: Bool = false
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    // MARK: User Action
    case binding(BindingAction<State>)
    case kakaoLoginButtonTapped
    case appleLoginButtonTapped
    case googleLoginButtonTapped
    
    // MARK: Inner Business Action
    case login(SocialLoginInfo)
    case fetchFolderList
    case putFcmPushToken
    case loginSuccessFlow(TokenInfo)
    
    // MARK: Inner SetState Action
    case setSocialLoginInfo(SocialLoginInfo)
    case setSaveKeychain(TokenInfo)
    case setSaveAnalyticsUserId(String)
    case setLoading(Bool)
    
    // MARK: Delegate Action
    public enum Delegate {
      case moveToOnboarding
      case moveToMainTab
    }
    
    case delegate(Delegate)
    
    // MARK: Present Action
    case loginFailAlertPresented
  }
  
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.keychainClient) private var keychainClient
  @Dependency(\.socialLogin) private var socialLogin
  @Dependency(\.authClient) private var authClient
  @Dependency(\.userClient) private var userClient
  @Dependency(\.folderClient) private var folderClient
  
  private enum ThrottleId {
    case kakaoLoginButton
    case appleLoginButton
    case googleLoginButton
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
      case .kakaoLoginButtonTapped:
        loginButtonTappedLog(.kakao)
        
        return .run(
          operation: { send in
            await send(.setLoading(true))
            
            let info = try await socialLogin.kakaoLogin()
            await send(.login(info))
          },
          catch: { error, send in
            debugPrint(error)
            await send(.setLoading(false))
            await send(.loginFailAlertPresented)
          }
        )
        .throttle(id: ThrottleId.kakaoLoginButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case .appleLoginButtonTapped:
        loginButtonTappedLog(.apple)
        
        return .run(
          operation: { send in
            await send(.setLoading(true))
            
            let info = try await socialLogin.appleLogin()
            await send(.login(info))
          },
          catch: { error, send in
            await send(.setLoading(false))
            
            guard let appleAuthError = error as? AppleErrorType else {
              await send(.loginFailAlertPresented)
              return
            }
            
            if case .dismissASAuthorizationController = appleAuthError {
              return
            }
            
            await send(.loginFailAlertPresented)
          }
        )
        .throttle(id: ThrottleId.appleLoginButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case .googleLoginButtonTapped:
        loginButtonTappedLog(.google)
        
        return .run(
          operation: { send in
            await send(.setLoading(true))
            
            let info = try await socialLogin.googleLogin()
            await send(.login(info))
          },
          catch: { error, send in
            await send(.setLoading(false))
            
            guard let googleAuthError = error as? GoogleErrorType else {
              await send(.loginFailAlertPresented)
              return
            }
            
            if case .dismissSignIn = googleAuthError {
              return
            }
            
            await send(.loginFailAlertPresented)
          }
        )
        .throttle(id: ThrottleId.googleLoginButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
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
              
            case .google:
              tokenInfo = try await authClient.requestGoogleLogin(info.idToken)
            }
            
            guard let tokenInfo else { return }
            
            await send(.setSaveKeychain(tokenInfo))
          },
          catch: { error, send in
            debugPrint(error)
            await send(.setLoading(false))
            await send(.loginFailAlertPresented)
          }
        )
        
      case .fetchFolderList:
        return .run(
          operation: { send in
            async let folderListResponse = try folderClient.getFolders()
            
            let folderList = try await folderListResponse
            
            await send(.setLoading(false))
            try? await Task.sleep(for: .seconds(0.2))
            
            if isCheckOnboarding(folderList) {
              await send(.delegate(.moveToOnboarding))
            } else {
              await send(.delegate(.moveToMainTab))
            }
          },
          catch: { error, send in
            debugPrint(error)
            await send(.setLoading(false))
            await send(.loginFailAlertPresented)
          }
        )
        
      case .putFcmPushToken:
        return .run(
          operation: { send in
            guard !userDefaultsClient.string(.fcmToken, "").isEmpty else { return }
            try await userClient.putFcmPushToken(userDefaultsClient.string(.fcmToken, ""))
          },
          catch: { error, send in
            debugPrint(error)
            await send(.setLoading(false))
            await send(.loginFailAlertPresented)
          }
        )
        
      case let .setSocialLoginInfo(info):
        state.loginInfo = info
        return .none
        
      case let .setSaveKeychain(token):
        return .run(
          operation: { send in
            try await keychainClient.save(.accessToken, token.accessToken)
            try await keychainClient.save(.refreshToken, token.refreshToken)
            
            await send(.putFcmPushToken)
            await send(.setSaveAnalyticsUserId(token.accessToken))
            await send(.fetchFolderList)
          },
          catch: { error, send in
            debugPrint(error)
            await send(.setLoading(false))
            await send(.loginFailAlertPresented)
          }
        )
        
      case let .setSaveAnalyticsUserId(accessToken):
        return .run(
          operation: { send in
            let userId = try await authClient.decodeUserId(accessToken)
            analyticsClient.setUserId(userId)
          },
          catch: { error, send in
            debugPrint(error)
            await send(.setLoading(false))
            await send(.loginFailAlertPresented)
          }
        )
        
      case let .setLoading(isLoading):
        state.isLoading = isLoading
        return .none
        
      case .loginFailAlertPresented:
        return .run { send in
          await alertClient.present(.init(
            title: "로그인 실패",
            description: """
                          로그인에 실패하였습니다. 
                          잠시 후 다시 시도해주세요.
                          """,
            buttonType: .singleButton(),
            rightButtonAction: {}
          ))
        }
        
      default:
        return .none
      }
    }
  }
}

// MARK: Private

extension LoginFeature {
  func isCheckOnboarding(_ folderList: [Folder]) -> Bool {
    guard !folderList.isEmpty else { return true }
    
    return folderList.count == 1 && folderList.first?.name == "블링크 소개"
  }
}

// MARK: Analytics Log

extension LoginFeature {
  private func loginButtonTappedLog(_ type: SocialLoginInfo.Socialtype) {
    var eventName: AnalyticsEventName?
    
    switch type {
    case .google:
      eventName = .googleLoginClicked
    case .kakao:
      eventName = .kakaoLoginClicked
    case .apple:
      eventName = .appleLoginClicked
    }
    
    guard let eventName else { return }
    
    analyticsClient.logEvent(.init(name: eventName, screen: .login))
  }
}
