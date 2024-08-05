//
//  RootView.swift
//  Features
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CoreKit

import ComposableArchitecture

public struct RootView: View {
  private let store: StoreOf<RootFeature>
  
  public init(store: StoreOf<RootFeature>) {
    self.store = store
  }
  
  public var body: some View {
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
      case .onBoardingSubject:
        if let store = store.scope(state: \.onBoardingSubject, action: \.onBoardingSubject) {
          OnboardingSubjectView(store: store)
        }
      case .onBoardingFlow:
        if let store = store.scope(state: \.onBoardingFlow, action: \.onBoardingFlow) {
          OnboardingFlowView(store: store)
        }
      case .mainTab:
        if let store = store.scope(state: \.mainTab, action: \.mainTab) {
          BKTabView(store: store)
        }
      }
    }
    .onOpenURL { url in
      store.send(.onOpenURL(url))
    }
    .onReceive(NotificationCenter.default.publisher(for: .tokenExpired)) { _ in
      #warning("재로그인 구현")
    }
    .animation(.spring, value: store.state)
    .task {
      await store
        .send(.onAppear)
        .finish()
    }
  }
}
