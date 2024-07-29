//
//  OnboardingFlowFeature.swift
//  Features
//
//  Created by kyuchul on 7/3/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

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
    
    // MARK: Delegate Action
    public enum Delegate {
      case moveToMainTab
    }
    
    case delegate(Delegate)
  }
  
  enum ThrottleId {
    case startButton
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .nextButtonTapped:
          state.selectedPage += 1
          return .none
        
      case .skipButtonTapped, .startButtonTapped:
        return .send(.delegate(.moveToMainTab))
          .throttle(id: ThrottleId.startButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      default:
        return .none
      }
    }
  }
}
