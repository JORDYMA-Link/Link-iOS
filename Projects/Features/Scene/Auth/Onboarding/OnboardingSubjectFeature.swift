//
//  OnboardingSubjectFeature.swift
//  Blink
//
//  Created by kyuchul on 6/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct OnboardingSubjectFeature {
  
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var subjects: Set<String> = []
    
    public init() {}
  }
  
  @CasePathable
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case selectSubject(String)
    case confirmButtonTapped
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
        } else if state.subjects.count < 3 {
          state.subjects.insert(subject)
        }
        return .none
      case .confirmButtonTapped:
        return .none
      }
    }
  }
}
