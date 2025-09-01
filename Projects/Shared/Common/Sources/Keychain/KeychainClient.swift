//
//  KeychainClient.swift
//  CoreKit
//
//  Created by kyuchul on 8/2/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import Security

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

extension KeychainClient: DependencyKey {
  public static var liveValue: KeychainClient {
    return Self(
      save: { type, value in
        let query: NSDictionary = .init(
          dictionary: [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: type.rawValue,
            kSecValueData: value.data(using: .utf8, allowLossyConversion: false)!
          ]
        )
        
        let status = SecItemAdd(query, nil)
        
        switch status {
        case errSecSuccess:
          break
        case errSecDuplicateItem:
          try updateKey(type, value: value)
        default:
          throw KeychainClientError.failToSave
        }
      },
      read: { type in
        readKey(type)
      },
      update: { type, value in
        try updateKey(type, value: value)
      },
      delete: { type in
        let keyChainQuery: NSDictionary = [
          kSecClass: kSecClassGenericPassword,
          kSecAttrAccount: type.rawValue
        ]
        
        let status = SecItemDelete(keyChainQuery)
        
        switch status {
        case noErr:
          break
        case errSecNoSuchKeychain:
          throw KeychainClientError.failToDelete
        case errSecItemNotFound:
          throw KeychainClientError.failToDelete
        default:
          throw KeychainClientError.failToDelete
        }
      }, 
      checkToTokenIsExist: {
        return readKey(.accessToken).isEmpty
      }
    )
  }
}

extension KeychainClient {
  private static func readKey(_ type: TokenType) -> String {
    let query: NSDictionary = .init(
      dictionary: [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: type.rawValue,
        kSecReturnData: true,
        kSecMatchLimit: kSecMatchLimitOne
      ]
    )
    
    var dataTypeReference: AnyObject?
    let status = withUnsafeMutablePointer(to: &dataTypeReference) {
      SecItemCopyMatching(query, UnsafeMutablePointer($0))
    }
    
    guard status == errSecSuccess,
          let data = dataTypeReference as? Data
    else { return .init() }
    
    return String(decoding: data, as: UTF8.self)
  }
  
  private static func updateKey(_ type: TokenType, value: String) throws {
    guard let data = value.data(using: .utf8) else { throw KeychainClientError.failToGetData }
    
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: type.rawValue
    ]
    
    let attributes: NSDictionary = [
      kSecValueData: data
    ]
    
    let status = SecItemUpdate(query, attributes)
    
    switch status {
    case errSecSuccess:
      break
    default:
      throw KeychainClientError.failToUpdate
    }
  }
}

public extension DependencyValues {
  var keychainClient: KeychainClient {
    get { self[KeychainClient.self] }
    set { self[KeychainClient.self] = newValue }
  }
}
