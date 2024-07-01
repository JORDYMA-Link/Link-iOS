//
//  RootFeature.swift
//  Features
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Common
import Services

import ComposableArchitecture

@Reducer
public struct RootFeature: Reducer {
  
  public init() {}
  
  @ObservableState
  public enum State: Equatable {
    case splash(SplashFeature.State = .init())
    case login(LoginFeature.State = .init())
    case onBoarding(OnboardingSubjectFeature.State = .init())
    case mainTab(BKTabFeature.State = .init())
    
    public init() { self = .splash() }
  }
  
  public enum Action {
    case onAppear
    case onOpenURL(URL)
    case changeScreen(State)
    
    case splash(SplashFeature.Action)
    case login(LoginFeature.Action)
    case onBoarding(OnboardingSubjectFeature.Action)
    case mainTab(BKTabFeature.Action)
  }
  
  @Dependency(\.userDefaultsClient) var userDefault
  @Dependency(\.socialLogin) var socialLogin
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        socialLogin.initKakaoSDK()
        
        return .run {  send in
          try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
          
          userDefault.set(true, .isFirstLanch)
          
          if try userDefault.bool(.isFirstLanch) {
            await send(.changeScreen(.login()), animation: .spring)
          } else {
            await send(.changeScreen(.mainTab()), animation: .spring)
          }
        }
        
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
    .ifCaseLet(\.onBoarding, action: \.onBoarding) { OnboardingSubjectFeature() }
    .ifCaseLet(\.mainTab, action: \.mainTab) { BKTabFeature() }
  }
}
