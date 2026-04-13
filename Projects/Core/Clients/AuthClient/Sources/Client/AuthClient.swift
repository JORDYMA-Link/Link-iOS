//
//  AuthClient.swift
//  AuthClient
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKCommon
import BKModel

import Dependencies

public struct AuthClient {
  /// 카카오로그인
  public var requestKakaoLogin: @Sendable (_ request: KakaoLoginRequest) async throws -> TokenInfo
  /// 애플로그인
  public var requestAppleLogin: @Sendable (_ idToken: String) async throws -> TokenInfo
  /// 구글로그인
  public var requestGoogleLogin: @Sendable (_ idToken: String) async throws -> TokenInfo
  /// 토큰재발급
  public var requestRegenerateToken: @Sendable (_ refreshToken: String) async throws -> TokenInfo
  /// 로그아웃
  public var logout: @Sendable (_ refreshToken: String) async throws -> Void
  /// 회원탈퇴
  public var signout: @Sendable (_ refreshToken: String) async throws -> Void
  /// 토큰 내 유저 아이디 디코딩
  public var decodeUserId: @Sendable (_ accessToken: String) async throws -> String
}

public extension DependencyValues {
  var authClient: AuthClient {
    get { self[AuthClient.self] }
    set { self[AuthClient.self] = newValue }
  }
}
