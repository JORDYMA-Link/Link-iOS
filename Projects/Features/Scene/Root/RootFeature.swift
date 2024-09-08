//
//  RootFeature.swift
//  Features
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

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
    case onAppear
    case onOpenURL(URL)
    case changeScreen(State)
    
    case refreshToken(Result<TokenInfo, Error>)
    
    case splash(SplashFeature.Action)
    case login(LoginFeature.Action)
    case onBoardingSubject(OnboardingSubjectFeature.Action)
    case onBoardingFlow(OnboardingFlowFeature.Action)
    case mainTab(BKTabFeature.Action)
  }
  
  @Dependency(\.userDefaultsClient) var userDefault
  @Dependency(\.keychainClient) var keychainClient
  @Dependency(\.socialLogin) var socialLogin
  @Dependency(\.authClient) var authClient
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run {  send in
          try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
          
          if keychainClient.checkToTokenIsExist() {
            await send(.changeScreen(.login()), animation: .spring)
          } else {
            await send(.refreshToken(Result { try await authClient.requestRegenerateToken(keychainClient.read(.refreshToken)) }))
          }
        }
        
      case let .refreshToken(.success(token)):
        return .run { send in
          try await keychainClient.update(.accessToken, token.accessToken)
          try await keychainClient.update(.refreshToken, token.refreshToken)
          
          await send(.changeScreen(.mainTab()), animation: .spring)
        } catch: { error, send in
          debugPrint(error)
          await send(.changeScreen(.login()), animation: .spring)
        }
        
      case .refreshToken(.failure):
        return .send(.changeScreen(.login()), animation: .spring)
        
      case .login(.delegate(.moveToOnboarding)):
        return .send(.changeScreen(.onBoardingSubject()), animation: .spring)
        
      case .onBoardingSubject(.delegate(.moveToOnboardingFlow)):
        return .send(.changeScreen(.onBoardingFlow()), animation: .spring)
        
      case .onBoardingSubject(.delegate(.moveToMainTab)), .onBoardingFlow(.delegate(.moveToMainTab)), .login(.delegate(.moveToMainTab)):
        return .send(.changeScreen(.mainTab()), animation: .spring)
        
      case let .onOpenURL(url):
        socialLogin.handleKakaoUrl(url)
        return .none
        
      case let .changeScreen(newState):
        state = newState
        return .none
        
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
