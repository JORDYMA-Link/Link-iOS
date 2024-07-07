//
//  LinkContentFeature.swift
//  Features
//
//  Created by kyuchul on 7/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Services
import Models

import ComposableArchitecture

@Reducer
public struct LinkContentFeature {
  @ObservableState
  public struct State: Equatable {
    
    public init() {}
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case closeButtonTapped
    
    // MARK: Inner Business Action
    
    // MARK: Inner SetState Action
  }
  
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .closeButtonTapped:
         return .run { _ in await self.dismiss() }
        
      default:
        return .none
      }
    }
  }
}
