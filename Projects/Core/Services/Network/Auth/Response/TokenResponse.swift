//
//  TokenResponse.swift
//  Services
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

public struct TokenResponse: Decodable {
  public let accessToken: String
  public let refreshToken: String
  
  public init(accessToken: String, refreshToken: String) {
    self.accessToken = accessToken
    self.refreshToken = refreshToken
  }
}

extension TokenResponse {
  public func toDomain() -> TokenInfo {
    return TokenInfo(
      accessToken: accessToken,
      refreshToken: refreshToken
    )
  }
}
