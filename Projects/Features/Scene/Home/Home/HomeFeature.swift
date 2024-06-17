//
//  HomeFeature.swift
//  Blink
//
//  Created by kyuchul on 6/7/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct HomeFeature: Reducer {
    @ObservableState
  public struct State: Equatable {
    }
    
  public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
  public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}


