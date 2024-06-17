//
//  SocailLoginClient.swift
//  CoreKit
//
//  Created by kyuchul on 6/17/24.
//  Copyright © 2024 com.jordyma.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

public struct SocialLoginClient {
  public var initKakaoSDK: @Sendable () -> Void
  public var handleKakaoUrl: @Sendable (URL) -> Void
  public var kakaoLogin: @Sendable () async throws -> SocialLogin
  public var appleLogin: @Sendable () async throws -> SocialLogin
}

extension SocialLoginClient: DependencyKey {
  public static var liveValue: SocialLoginClient {
    let kakaoLogin = KakaoLogin()
    let appleLogin = AppleLogin()
    
    return Self(
      initKakaoSDK: {
        kakaoLogin.initSDK()
      },
      handleKakaoUrl: {
        kakaoLogin.handleKakaoTalkLoginUrl(url: $0)
      },
      kakaoLogin: {
        try await kakaoLogin.kakaoLogin()
      },
      appleLogin: {
        try await appleLogin.appleLogin()
      }
    )
  }
}

public extension DependencyValues {
  var socialLogin: SocialLoginClient {
    get { self[SocialLoginClient.self] }
    set { self[SocialLoginClient.self] = newValue }
  }
}
