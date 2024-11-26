//
//  OnboardingFlowFeature.swift
//  Features
//
//  Created by kyuchul on 7/3/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Analytics
import Services

import ComposableArchitecture

@Reducer
public struct OnboardingFlowFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var selectedPage = 0
    var isStart: Bool {
      selectedPage == 2 ? true : false
    }
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case skipButtonTapped
    case nextButtonTapped
    case startButtonTapped
    
    // MARK: Inner SetState Action
    case setPage
    
    // MARK: Delegate Action
    public enum Delegate {
      case moveToMainTab
    }
    
    case delegate(Delegate)
  }
  
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(\.userDefaultsClient) var userDefault
  
  enum ThrottleId {
    case skipButton
    case startButton
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .nextButtonTapped:
        nextButtonTappedLog()
        
        return .send(.setPage)
        
      case .skipButtonTapped:
        skipButtonTappedLog()
        
        return .send(.delegate(.moveToMainTab))
          .throttle(id: ThrottleId.skipButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case .startButtonTapped:
        startButtonTappedLog()
        
        return .send(.delegate(.moveToMainTab))
          .throttle(id: ThrottleId.startButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case .setPage:
        state.selectedPage += 1
        return .none
        
      default:
        return .none
      }
    }
  }
}

// MARK: Analytics Log

extension OnboardingFlowFeature  {
  private func skipButtonTappedLog() {
    analyticsClient.logEvent(.init(name: .onboardingSkipClicked, screen: .onboarding))
  }
  
  private func nextButtonTappedLog() {
    analyticsClient.logEvent(.init(name: .onboardingNextClicked, screen: .onboarding))
  }
  
  private func startButtonTappedLog() {
    analyticsClient.logEvent(.init(name: .onboardingConfirmClicked, screen: .onboarding))
  }
}
