//
//  AuthClient.swift
//  Services
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture
import Moya

public struct AuthClient {
  public var requestKakaoLogin: @Sendable (_ request: KakaoLoginRequest) async throws -> TokenInfo
  public var requestAppleLogin: @Sendable (_ idToken: String) async throws -> TokenInfo
  public var requestRegenerateToken: @Sendable (_ refreshToken: String) async throws -> TokenInfo
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

