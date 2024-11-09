//
//  OnboardingSubjectFeature.swift
//  Blink
//
//  Created by kyuchul on 6/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Analytics
import Services

import ComposableArchitecture

@Reducer
public struct OnboardingSubjectFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var subjects: Set<String> = []
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    // MARK: User Action
    case binding(BindingAction<State>)
    case selectSubject(String)
    case skipButtonTapped
    case confirmButtonTapped
    
    // MARK: Delegate Action
    public enum Delegate {
      case moveToOnboardingFlow
      case moveToMainTab
    }
    
    case delegate(Delegate)
  }
  
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(\.userDefaultsClient) private var userDefault
  @Dependency(\.folderClient) private var folderClient
  
  private enum ThrottleId {
    case confirmButton
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case let .selectSubject(subject):
        if state.subjects.contains(subject) {
          state.subjects.remove(subject)
        } else if state.subjects.count < 5 {
          state.subjects.insert(subject)
        }
        return .none
        
      case .skipButtonTapped:
        skipButtonTappedLog()
        
        return .send(.delegate(.moveToMainTab))
        
      case .confirmButtonTapped:
        confirmButtonTappedLog()
        
        return .run(
          operation: { [state] send in
            let topics = state.subjects.map { $0 }
            _ = try await folderClient.postOnboardingFolder(topics)

            return await send(.delegate(.moveToOnboardingFlow))
          },
          catch: { error, send in
            print(error)
          }
        )
        .throttle(id: ThrottleId.confirmButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      default:
        return .none
      }
    }
  }
}

// MARK: Analytics Log

extension OnboardingSubjectFeature  {
  private func confirmButtonTappedLog() {
    analyticsClient.logEvent(event: .init(name: .onboardingConfirmClicked, screen: .onboarding_subject))
  }
  
  private func skipButtonTappedLog() {
    analyticsClient.logEvent(event: .init(name: .onboardingSkipClicked, screen: .onboarding_subject))
  }
}
