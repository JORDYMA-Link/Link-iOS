//
//  SearchKeywordFeature.swift
//  Blink
//
//  Created by kyuchul on 6/10/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
struct SearchKeywordFeature: Reducer {
    @ObservableState
    struct State: Equatable {
        var text = ""
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
            }
        }
    }
}
