//
//  SplashFeature.swift
//  Blink
//
//  Created by kyuchul on 6/7/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Analytics
import Common
import BKModel
import Services

import ComposableArchitecture

@Reducer
public struct SplashFeature {
  public init() {}
  
  public struct State: Equatable {
    public init() {}
  }
  
  public enum Action {
    // MARK: User Action
    case onAppear
    
    // MARK: Inner Business Action
    case migrateDeviceInfo
    case refreshToken(Result<TokenInfo, Error>)
    case putFcmPushToken(Result<Void, Error>)
    
    // MARK: Inner SetState Action
    case setUpdateToken(TokenInfo)
    case setSaveAnalyticsUserId(String)
    case setPopGestureEnabled(Bool)
    case setFirstLaunch(Bool)
    case setDeleteKeychain
    case setDeleteUserDefaults
    
    // MARK: Delegate Action
    public enum Delegate {
      case login
      case main
    }
    case delegate(Delegate)
  }
  
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.keychainClient) private var keychainClient
  @Dependency(\.socialLogin) private var socialLogin
  @Dependency(\.authClient) private var authClient
  @Dependency(\.userClient) private var userClient
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          if userDefaultsClient.bool(.isFirstLaunch, true) {
            await send(.migrateDeviceInfo)
          }
          
          try await Task.sleep(for: .seconds(2))
          
          if keychainClient.checkToTokenIsExist() {
            return await send(.delegate(.login))
          } else {
            return await send(.refreshToken(Result { try await authClient.requestRegenerateToken(keychainClient.read(.refreshToken)) }))
          }
        }
        
      case .migrateDeviceInfo:
        return .concatenate(
          .merge(
            .send(.setDeleteKeychain),
            .send(.setDeleteUserDefaults)
          ),
          .merge(
            .send(.setPopGestureEnabled(true)),
            .send(.setFirstLaunch(false))
          )
        )
        
      case let .refreshToken(.success(token)):
        return .run { send in
          await send(.setUpdateToken(token))
          await send(.setSaveAnalyticsUserId(token.accessToken))
          
          guard !userDefaultsClient.string(.fcmToken, "").isEmpty else {
            await send(.delegate(.main))
            return
          }
          
          await send(.putFcmPushToken(Result { try await userClient.putFcmPushToken(userDefaultsClient.string(.fcmToken, "")) }))
          await send(.delegate(.main))
        }
        
      case .refreshToken(.failure):
        return .send(.delegate(.login))
        
      case .putFcmPushToken(.success):
        return .none
        
      case .putFcmPushToken(.failure):
        return .send(.delegate(.main))
        
      case let .setUpdateToken(token):
        return .run(
          operation: { send in
            try await keychainClient.update(.accessToken, token.accessToken)
            try await keychainClient.update(.refreshToken, token.refreshToken)
          }
          ,catch: { error, send in
            debugPrint(error)
          }
        )
        
      case let .setSaveAnalyticsUserId(accessToken):
        return .run(
          operation: { send in
            let userId = try await authClient.decodeUserId(accessToken)
            analyticsClient.setUserId(userId)
          }
          ,catch: { error, send in
            debugPrint(error)
          }
        )
        
      case let .setPopGestureEnabled(isEnabled):
        userDefaultsClient.set(isEnabled, .isPopGestureEnabled)
        return .none
        
      case let .setFirstLaunch(isFirstLaunch):
        userDefaultsClient.set(isFirstLaunch, .isFirstLaunch)
        return .none
        
      case .setDeleteKeychain:
        return .run(
          operation: { send in
            try await keychainClient.delete(.accessToken)
            try await keychainClient.delete(.refreshToken)
          }
          ,catch: { error, send in
            debugPrint(error)
          }
        )
        
      case .setDeleteUserDefaults:
        userDefaultsClient.reset()
        return .none
        
      default:
        return .none
      }
    }
  }
}
