//
//  KeychainClient.swift
//  KeychainClient
//
//  Created by kyuchul on 8/2/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Dependencies

public enum KeychainClientError: Error {
  case failToSave
  case failToGetData
  case failToUpdate
  case failToDelete
}

public struct KeychainClient {
  public enum TokenType: String {
    case accessToken = "accessToken"
    case refreshToken = "refreshToken"
  }

  public var save: @Sendable (_ type: TokenType, _ value: String) async throws -> Void
  public var read: @Sendable (_ type: TokenType) -> String
  public var update: @Sendable (_ type: TokenType, _ value: String) async throws -> Void
  public var delete: @Sendable (_ type: TokenType) async throws -> Void
  public var checkToTokenIsExist: @Sendable () -> Bool
}

public extension DependencyValues {
  var keychainClient: KeychainClient {
    get { self[KeychainClient.self] }
    set { self[KeychainClient.self] = newValue }
  }
}
