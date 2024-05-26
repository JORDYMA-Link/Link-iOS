//
//  StorageBoxFeature.swift
//  Blink
//
//  Created by kyuchul on 5/24/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation
import Combine

import UseCase
import Entity

import ComposableArchitecture

struct StorageBoxFeature: Reducer {
    
    // State를 통해 앱의 상태 변화를 업데이트하는것이 초점이기에 이 앱의 상태들이 변경되면 바인딩된 뷰를 자동으로 업데이트
    // State가 참조 타입이라면 객체 참조가 결국 동일하기에 이를 값의 변화로 보지 않기에 Struct 타입이 적절
    // 상태는 중복되지 않고 각 고유하기에 이 상태의 변화를 비교하기 위해 Equatable을 따라야함
    struct State: Equatable {
        @BindingState var showingMenuBottomSheet: Bool = false
    }
    
    enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case showMenuBottomSheet
    }
    
    // 리듀서에서는 Action을 기반으로 현재 State를 다음 State로 어떻게 바꿀지 실제적인 구현을 해주는 역할의 프로토콜
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .showMenuBottomSheet:
                state.showingMenuBottomSheet = true
                return .none
            case .binding:
                return .none
            }
        }
    }
}
