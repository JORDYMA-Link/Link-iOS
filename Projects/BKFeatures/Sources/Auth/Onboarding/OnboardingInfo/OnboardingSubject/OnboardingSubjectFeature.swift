//
//  OnboardingSubjectFeature.swift
//  Blink
//
//  Created by kyuchul on 6/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import AnalyticsClient
import UserClient
import UserDefaultsClient

import ComposableArchitecture

@Reducer
public struct OnboardingSubjectFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var subjects: Set<String> = []
    let jobField: String
    let ageGroup: String
    let gender: String
    
    public init(
      jobField: String,
      ageGroup: String,
      gender: String
    ) {
      self.jobField = jobField
      self.ageGroup = ageGroup
      self.gender = gender
    }
  }
  
  public enum Action: BindableAction, Equatable {
    // MARK: User Action
    case binding(BindingAction<State>)
    case selectSubject(String)
    case backButtonTapped
    case skipButtonTapped
    case confirmButtonTapped
    
    // MARK: Delegate Action
    public enum Delegate {
      case backButtonTapped
      case skipButtonTapped
      case confirmButtonTapped
    }
    
    case delegate(Delegate)
  }
  
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(\.userDefaultsClient) private var userDefault
  @Dependency(\.folderClient) private var folderClient
  @Dependency(\.userClient) private var userClient
  
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
        
      case .backButtonTapped:
        return .send(.delegate(.backButtonTapped))
        
      case .skipButtonTapped:
        skipButtonTappedLog()
        
        return .send(.delegate(.skipButtonTapped))
        
      case .confirmButtonTapped:
        confirmButtonTappedLog()
        
        return .run(
          operation: { [state] send in
            let topics = state.subjects.map { $0 }
            _ = try await folderClient.postOnboardingFolder(topics)
            _ = try await userClient.postOnboarding(state.jobField, state.ageGroup, state.gender)
            
            return await send(.delegate(.confirmButtonTapped))
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
    analyticsClient.logEvent(.init(name: .onboardingSubjectConfirmClicked, screen: .onboarding_subject))
  }
  
  private func skipButtonTappedLog() {
    analyticsClient.logEvent(.init(name: .onboardingSubjectSkipClicked, screen: .onboarding_subject))
  }
}
