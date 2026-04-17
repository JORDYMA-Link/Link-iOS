//
//  SocialLoginClient+Live.swift
//  Services
//
//  Created by kyuchul on 6/17/24.
//  Copyright © 2024 com.jordyma.blink. All rights reserved.
//

import Foundation

import BKModel

import Dependencies

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
