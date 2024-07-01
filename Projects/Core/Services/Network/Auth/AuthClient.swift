//
//  AuthClient.swift
//  Services
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import ComposableArchitecture
import Moya

public struct AuthClient {
  public var requestKakaoLogin: @Sendable (_ request: KakaoLoginRequest) async throws -> TokenResponse
}

extension AuthClient: DependencyKey {
  public static var liveValue: AuthClient {
    let authProvider = CommonMoyaProvider<AuthEndpoint>(isInterceptor: false)
    
    return Self(
      requestKakaoLogin: {
        try await authProvider.request(.kakaoLogin(request: $0), modelType: TokenResponse.self)
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

