//
//  RootFeature.swift
//  Features
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Analytics
import Common
import Models
import Services

import ComposableArchitecture

@Reducer
public struct RootFeature: Reducer {
  public init() {}
  
  @ObservableState
  public enum State: Equatable {
    case splash(SplashFeature.State = .init())
    case login(LoginFeature.State = .init())
    case onBoardingSubject(OnboardingSubjectFeature.State = .init())
    case onBoardingFlow(OnboardingFlowFeature.State = .init())
    case mainTab(BKTabFeature.State = .init())
    
    public init() { self = .splash() }
  }
  
  public enum Action {
    // MARK: User Action
    case onAppear
    case onOpenURL(URL)
    
    // MARK: Inner Business Action
    case refreshToken(Result<TokenInfo, Error>)
    case putFcmPushToken(Result<Void, Error>)
    
    // MARK: Inner SetState Action
    case changeScreen(State)
    case setUpdateToken(TokenInfo)
    case setSaveAnalyticsUserId(String)
    case setPopGestureEnabled(Bool)
    
    // MARK: Child Action
    case splash(SplashFeature.Action)
    case login(LoginFeature.Action)
    case onBoardingSubject(OnboardingSubjectFeature.Action)
    case onBoardingFlow(OnboardingFlowFeature.Action)
    case mainTab(BKTabFeature.Action)
  }
  
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.keychainClient) private var keychainClient
  @Dependency(\.socialLogin) private var socialLogin
  @Dependency(\.authClient) private var authClient
  @Dependency(\.userClient) private var userClient
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run {  send in
          try await Task.sleep(for: .seconds(2))
          
          await send(.setPopGestureEnabled(true))
          
          if keychainClient.checkToTokenIsExist() {
            await send(.changeScreen(.login()))
          } else {
            await send(.refreshToken(Result { try await authClient.requestRegenerateToken(keychainClient.read(.refreshToken)) }))
          }
        }
        
      case let .onOpenURL(url):
        socialLogin.handleKakaoUrl(url)
        return .none
        
      case let .refreshToken(.success(token)):
        return .run { send in
          await send(.setUpdateToken(token))
          await send(.setSaveAnalyticsUserId(token.accessToken))

          guard !userDefaultsClient.string(.fcmToken, "").isEmpty else {
            await send(.changeScreen(.mainTab()))
            return
          }
          
          await send(.putFcmPushToken(Result { try await userClient.putFcmPushToken(userDefaultsClient.string(.fcmToken, "")) }))
          await send(.changeScreen(.mainTab()))
        }
        
      case .refreshToken(.failure):
        return .send(.changeScreen(.login()))
        
      case .putFcmPushToken(.success):
        return .none
        
      case .putFcmPushToken(.failure):
        return .send(.changeScreen(.mainTab()))
        
      case let .changeScreen(newState):
        state = newState
        return .none
        
      case let .setUpdateToken(token):
        return .run { _ in
          try await keychainClient.update(.accessToken, token.accessToken)
          try await keychainClient.update(.refreshToken, token.refreshToken)
        }
        
      case let .setSaveAnalyticsUserId(accessToken):
        return .run { _ in
          let userId = try await authClient.decodeUserId(accessToken)
          analyticsClient.setUserId(userID: userId)
        }
        
      case let .setPopGestureEnabled(isEnabled):
        userDefaultsClient.set(isEnabled, .isPopGestureEnabled)
        return .none
        
        /// - MainTab Delegate
      case .mainTab(.delegate(.logout)), .mainTab(.delegate(.signout)):
        return .run { send in await send(.changeScreen(.login())) }
        
        /// - Login Delegate
      case .login(.delegate(.moveToOnboarding)):
        return .send(.changeScreen(.onBoardingSubject()))
        
      case .login(.delegate(.moveToMainTab)):
        return .send(.changeScreen(.mainTab()))
        
        /// - OnBoardingSubject Delegate
      case .onBoardingSubject(.delegate(.moveToOnboardingFlow)):
        return .send(.changeScreen(.onBoardingFlow()), animation: .spring)
        
      case .onBoardingSubject(.delegate(.moveToMainTab)):
        return .send(.changeScreen(.mainTab()))
        
        /// - OnBoardingFlow Delegate
      case .onBoardingFlow(.delegate(.moveToMainTab)):
        return .send(.changeScreen(.mainTab()), animation: .spring)
        
      default:
        return .none
      }
    }
    .ifCaseLet(\.splash, action: \.splash) { SplashFeature() }
    .ifCaseLet(\.login, action: \.login) { LoginFeature() }
    .ifCaseLet(\.onBoardingSubject, action: \.onBoardingSubject) { OnboardingSubjectFeature() }
    .ifCaseLet(\.onBoardingFlow, action: \.onBoardingFlow) { OnboardingFlowFeature() }
    .ifCaseLet(\.mainTab, action: \.mainTab) { BKTabFeature() }
  }
}
