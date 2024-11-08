//
//  AuthClient.swift
//  Services
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Common
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
  /// 토큰 내 유저 아이디 디코딩
  public var decodeUserId: @Sendable (_ accessToken: String) async throws -> String
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
      }, 
      decodeUserId: { accessToken in
        return try await self.extractUserIdFromToken(accessToken)
      }
    )
  }
}

private extension AuthClient {
  enum DecodeUserIdError: Error {
    case invalidFormat
    case invalidBase64
    case invalidJSON
    case userIdNotFound
  }
  
  static func extractUserIdFromToken(_ accessToken: String) async throws -> String {
    let segments = accessToken.components(separatedBy: ".")
    guard segments.count > 1, let segment = segments[safe: 1] else {
      throw DecodeUserIdError.invalidFormat
    }
    
    guard let payloadData = Data(base64URLEncoded: segment) else {
      throw DecodeUserIdError.invalidBase64
    }
    
    guard let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] else {
      throw DecodeUserIdError.invalidJSON
    }
    
    guard let userId = payload["user_id"] as? Int else {
      throw DecodeUserIdError.userIdNotFound
    }
    
    return String(userId)
  }
}

public extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}

