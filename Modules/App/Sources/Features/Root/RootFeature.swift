//
//  RootFeature.swift
//  Blink
//
//  Created by kyuchul on 6/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Util

import ComposableArchitecture

@Reducer
struct RootFeature: Reducer {
    @ObservableState
    enum State: Equatable {
        case splash(SplashFeature.State = .init())
        case login(LoginFeature.State = .init())
        case onBoarding(OnboardingSubjectFeature.State = .init())
        case mainTab(BKTabFeature.State = .init())
        
        init() { self = .splash() }
    }
    
    enum Action {
        case onAppear
        case changeScreen(State)
        
        case splash(SplashFeature.Action)
        case login(LoginFeature.Action)
        case onBoarding(OnboardingSubjectFeature.Action)
        case mainTab(BKTabFeature.Action)
    }
    
    @Dependency(\.userDefaultsClient) var userDefault
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run {  send in
                    try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
                    
                    userDefault.set(false, .isFirstLanch)
                    
                    if userDefault.bool(.isFirstLanch) ?? true {
                        await send(.changeScreen(.login()), animation: .spring)
                    } else {
                        await send(.changeScreen(.mainTab()), animation: .spring)
                    }
                }
                
            case let .changeScreen(newState):
                state = newState
                return .none
            default:
                return .none
            }
        }
        .ifCaseLet(\.splash, action: \.splash) { SplashFeature() }
        .ifCaseLet(\.login, action: \.login) { LoginFeature() }
        .ifCaseLet(\.onBoarding, action: \.onBoarding) { OnboardingSubjectFeature() }
        .ifCaseLet(\.mainTab, action: \.mainTab) { BKTabFeature() }
    }
}
