//
//  SocailLoginClient.swift
//  CoreKit
//
//  Created by kyuchul on 6/17/24.
//  Copyright © 2024 com.jordyma.blink. All rights reserved.
//

import Foundation

import BKModel

import ComposableArchitecture

public struct SocialLoginClient {
  public var initKakaoSDK: @Sendable () -> Void
  public var handleGoogleUrl: @Sendable (URL) -> Void
  public var handleKakaoUrl: @Sendable (URL) -> Void
  public var kakaoLogin: @Sendable () async throws -> SocialLoginInfo
  public var appleLogin: @Sendable () async throws -> SocialLoginInfo
  public var googleLogin: @Sendable () async throws -> SocialLoginInfo
}

extension SocialLoginClient: DependencyKey {
  public static var liveValue: SocialLoginClient {
    let googleLogin = GoogleLogin()
    let kakaoLogin = KakaoLogin()
    let appleLogin = AppleLogin()
    
    return Self(
      initKakaoSDK: {
        kakaoLogin.initSDK()
      },
      handleGoogleUrl: {
        googleLogin.handleGoogleLoginUrl(url: $0)
      },
      handleKakaoUrl: {
        kakaoLogin.handleKakaoTalkLoginUrl(url: $0)
      },
      kakaoLogin: {
        try await kakaoLogin.kakaoLogin()
      },
      appleLogin: {
        try await appleLogin.appleLogin()
      },
      googleLogin: {
        try await googleLogin.googleLogin()
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
