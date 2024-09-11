//
//  AuthClient.swift
//  Services
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import Dependencies

public struct AuthClient {
  /// 카카오로그인
  public var requestKakaoLogin: @Sendable (_ request: KakaoLoginRequest) async throws -> TokenInfo
  /// 애플로그인
  public var requestAppleLogin: @Sendable (_ idToken: String) async throws -> TokenInfo
  /// 토큰재발급
  public var requestRegenerateToken: @Sendable (_ refreshToken: String) async throws -> TokenInfo
  /// 로그아웃
  public var logout: @Sendable (_ refreshToken: String) async throws -> Void
  /// 회원탈퇴
  public var signout: @Sendable (_ refreshToken: String) async throws -> Void
}

extension AuthClient: DependencyKey {
  public static var liveValue: AuthClient {
    let authProvider = Provider<AuthEndpoint>(isRetry: false)
    
    return Self(
      requestKakaoLogin: {
        let responseDTO: TokenResponse = try await authProvider.request(.kakaoLogin(request: $0), modelType: TokenResponse.self)
        return responseDTO.toDomain()
      },
      requestAppleLogin: { idToken in
        let responseDTO: TokenResponse = try await authProvider.request(.appleLogin(idToken: idToken), modelType: TokenResponse.self)
        return responseDTO.toDomain()
      },
      requestRegenerateToken: { refreshToken in
        let responseDTO: TokenResponse = try await authProvider.request(.regenerateToken(refreshToken: refreshToken), modelType: TokenResponse.self)
        return responseDTO.toDomain()
      },
      logout: { refreshToken in
        return try await authProvider.requestPlain(.logout(refreshToken: refreshToken))
      },
      signout: { refreshToken in
        return try await authProvider.requestPlain(.signout(refreshToken: refreshToken))
      }
    )
  }
}

public extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}

