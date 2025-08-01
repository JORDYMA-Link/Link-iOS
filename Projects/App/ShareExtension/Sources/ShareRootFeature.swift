//
//  ShareRootFeature.swift
//  ShareExtension
//
//  Created by 김규철 on 8/1/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Common

import ComposableArchitecture

// MARK: - ShareRootFeature

@Reducer
struct ShareRootFeature {
  @ObservableState
  struct State {
    var accessToken: String = ""
    var refreshToken: String = ""
    var isLoading: Bool = false
  }
  
  enum Action {
    case onAppear
    case loadTokens
    case closeButtonTapped
  }
  
  @Dependency(\.keychainClient) var keychainClient
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.loadTokens)
        
      case .loadTokens:
        state.isLoading = true
        let accessToken = keychainClient.read(.accessToken)
        let refreshToken = keychainClient.read(.refreshToken)
        
        state.accessToken = accessToken.isEmpty ? "토큰 없음" : "토큰 있음 (\(accessToken.prefix(10))...)"
        state.refreshToken = refreshToken.isEmpty ? "토큰 없음" : "토큰 있음 (\(refreshToken.prefix(10))...)"
        state.isLoading = false
        
        return .none
        
      case .closeButtonTapped:
        return .none
      }
    }
  }
}
