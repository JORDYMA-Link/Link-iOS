//
//  RootView.swift
//  Blink
//
//  Created by kyuchul on 6/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

struct RootView: View {
    private let store: StoreOf<RootFeature>
    
    init(store: StoreOf<RootFeature>) {
         self.store = store
     }
    
    var body: some View {
        Group {
            switch store.state {
            case .splash:
                if let store = store.scope(state: \.splash, action: \.splash) {
                    SplashView(store: store)
                }
            case .login:
                if let store = store.scope(state: \.login, action: \.login) {
                    LoginView(store: store)
                }
            case .onBoarding:
                if let store = store.scope(state: \.onBoarding, action: \.onBoarding) {
                    OnboardingSubjectView(store: store)
                }
            case .mainTab:
                if let store = store.scope(state: \.mainTab, action: \.mainTab) {
                    BKTabView(store: store)
                }
            }
        }
        .animation(.spring, value: store.state)
        .task {
            await store
                .send(.onAppear)
                .finish()
        }
    }
}
