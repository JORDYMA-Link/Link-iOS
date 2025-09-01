//
//  RootFeature.swift
//  Features
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Services

import ComposableArchitecture

@Reducer
public struct RootFeature {
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
    case onOpenGoogleURL(URL)
    case onOpenKakaoURL(URL)
    
    // MARK: App LifeCycle
    case background
    case inactive
    case active
    
    // MARK: Inner Business Action
    case requestATTrackingAuthorization
    
    // MARK: Inner SetState Action
    case changeScreen(State)
    
    // MARK: Child Action
    case splash(SplashFeature.Action)
    case login(LoginFeature.Action)
    case onBoardingFlow(OnboardingFlowFeature.Action)
    case onBoardingSubject(OnboardingSubjectFeature.Action)
    case mainTab(BKTabFeature.Action)
  }
  
  @Dependency(ATTrackingManagerClient.self) private var attrackingManagerClient
  @Dependency(\.socialLogin) private var socialLogin
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .none
        
      case let .onOpenGoogleURL(url):
        socialLogin.handleGoogleUrl(url)
        return .none
        
      case let .onOpenKakaoURL(url):
        socialLogin.handleKakaoUrl(url)
        return .none
        
      case .background:
        return .none
        
      case .inactive:
        return .none
        
      case .active:
        return .run { send in
          await send(.requestATTrackingAuthorization)
        }
        
      case .requestATTrackingAuthorization:
        return .run { send in
          if attrackingManagerClient.trackingAuthorizationStatus() == .notDetermined {
            await attrackingManagerClient.requestTrackingAuthorization()
          }
        }

      case let .changeScreen(newState):
        state = newState
        return .none
        
        /// - Splash Delegate
      case .splash(.delegate(.login)):
        return .send(.changeScreen(.login()))
        
      case .splash(.delegate(.main)):
        return .send(.changeScreen(.mainTab()))
        
        /// - MainTab Delegate
      case .mainTab(.delegate(.logout)), .mainTab(.delegate(.signout)):
        return .run { send in await send(.changeScreen(.login())) }
        
        /// - Login Delegate
      case .login(.delegate(.moveToOnboarding)):
        return .send(.changeScreen(.onBoardingFlow()))
        
      case .login(.delegate(.moveToMainTab)):
        return .send(.changeScreen(.mainTab()))
        
        /// - OnBoardingFlow Delegate
      case .onBoardingFlow(.delegate(.moveToOnboardingSubject)):
        return .send(.changeScreen(.onBoardingSubject()), animation: .spring)
        
        /// - OnBoardingSubject Delegate
      case .onBoardingSubject(.delegate(.moveToOnboardingFlow)):
        return .send(.changeScreen(.onBoardingFlow()), animation: .spring)
        
      case .onBoardingSubject(.delegate(.moveToMainTab)):
        return .send(.changeScreen(.mainTab()))
        
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
