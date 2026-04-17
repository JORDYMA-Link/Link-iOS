//
//  UserDefaultsClient.swift
//  UserDefaultsClient
//
//  Created by kyuchul on 6/8/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Dependencies

public struct UserDefaultsClient {
  public enum UserDefaultsKey: String {
    case isFirstLaunch
    case fcmToken
    case isPopGestureEnabled
    case recentSearches
    case latestUnsavedSummaryFeedId
  }

  public var string: @Sendable (_ forKey: UserDefaultsKey, _ default: String) -> String
  public var integer: @Sendable (_ forKey: UserDefaultsKey, _ default: Int) -> Int
  public var bool: @Sendable (_ forKey: UserDefaultsKey, _ default: Bool) -> Bool
  public var float: @Sendable (_ forKey: UserDefaultsKey, _ default: Float) -> Float
  public var double: @Sendable (_ forKey: UserDefaultsKey, _ default: Double) -> Double
  public var data: @Sendable (_ forKey: UserDefaultsKey, _ default: Data) -> Data
  public var stringArray: @Sendable (_ forKey: UserDefaultsKey, _ default: [String]) -> [String]
  public var object: @Sendable (_ forKey: UserDefaultsKey, _ default: Any) -> Any
  public var set: @Sendable (_ value: Any, _ forKey: UserDefaultsKey) -> Void
  public var removeObject: @Sendable (_ forKey: UserDefaultsKey) -> Void
  public var reset: @Sendable () -> Void

  public func codableObject<T: Codable>(_ type: T.Type, forKey key: String, defaultValue: T) -> T {
    guard let data = UserDefaults.standard.data(forKey: key) else {
      return defaultValue
    }

    let decoder = JSONDecoder()
    do {
      let object = try decoder.decode(type, from: data)
      return object
    } catch {
      print("Failed to decode \(type) from UserDefaults with key \(key): \(error)")
      return defaultValue
    }
  }

  public func setCodable<T: Codable>(_ value: T, forKey key: String) {
    let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(value)
      UserDefaults.standard.set(data, forKey: key)
    } catch {
      print("Failed to encode \(value) for key \(key): \(error)")
    }
  }
}

public extension DependencyValues {
  var userDefaultsClient: UserDefaultsClient {
    get { self[UserDefaultsClient.self] }
    set { self[UserDefaultsClient.self] = newValue }
  }
}
