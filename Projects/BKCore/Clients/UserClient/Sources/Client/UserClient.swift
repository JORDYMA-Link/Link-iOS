//
//  UserClient.swift
//  UserClient
//
//  Created by 문정호 on 8/25/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKModel

import Dependencies
import DependenciesMacros

public struct UserClient {
  public var getUserProfile: @Sendable () async throws -> Setting
  public var requestUserProfile: @Sendable (_ nickname: String) async throws -> Setting
  public var putFcmPushToken: @Sendable (_ pushToken: String) async throws -> Void
  public var postOnboarding: @Sendable (_ jobField: String, _ birthYear: String, _ gender: String) async throws -> Void
}

public extension DependencyValues {
  var userClient: UserClient {
    get { self[UserClient.self] }
    set { self[UserClient.self] = newValue }
  }
}
