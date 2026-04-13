//
//  SocialLoginClient.swift
//  Services
//
//  Created by kyuchul on 6/17/24.
//  Copyright © 2024 com.jordyma.blink. All rights reserved.
//

import Foundation

import BKModel

import Dependencies

public struct SocialLoginClient {
  public var initKakaoSDK: @Sendable () -> Void
  public var handleGoogleUrl: @Sendable (URL) -> Void
  public var handleKakaoUrl: @Sendable (URL) -> Void
  public var kakaoLogin: @Sendable () async throws -> SocialLoginInfo
  public var appleLogin: @Sendable () async throws -> SocialLoginInfo
  public var googleLogin: @Sendable () async throws -> SocialLoginInfo
}

public extension DependencyValues {
  var socialLogin: SocialLoginClient {
    get { self[SocialLoginClient.self] }
    set { self[SocialLoginClient.self] = newValue }
  }
}
