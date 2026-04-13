//
//  UserDefaultsClient+Live.swift
//  UserDefaultsClient
//
//  Created by kyuchul on 6/8/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Dependencies

extension UserDefaultsClient: DependencyKey {
  static func userDefaultsObject<T>(_ type: T.Type, forKey key: String, defaultValue: T) -> T {
    guard let value = UserDefaults.standard.object(forKey: key) as? T else {
      return defaultValue
    }

    return value
  }

  static func userDefaultsArray<T>(_ type: T.Type, forKey key: String, defaultValue: T) -> T {
    guard let value = UserDefaults.standard.array(forKey: key) as? T else {
      return defaultValue
    }

    return value
  }

  public static var liveValue: UserDefaultsClient {
    return Self(
      string: { key, defaultValue in
        return userDefaultsObject(String.self, forKey: key.rawValue, defaultValue: defaultValue)
      },
      integer: { key, defaultValue in
        return userDefaultsObject(Int.self, forKey: key.rawValue, defaultValue: defaultValue)
      },
      bool: { key, defaultValue in
        return userDefaultsObject(Bool.self, forKey: key.rawValue, defaultValue: defaultValue)
      },
      float: { key, defaultValue in
        return userDefaultsObject(Float.self, forKey: key.rawValue, defaultValue: defaultValue)
      },
      double: { key, defaultValue in
        return userDefaultsObject(Double.self, forKey: key.rawValue, defaultValue: defaultValue)
      },
      data: { key, defaultValue in
        return userDefaultsObject(Data.self, forKey: key.rawValue, defaultValue: defaultValue)
      },
      stringArray: { key, defaultValue in
        return userDefaultsArray([String].self, forKey: key.rawValue, defaultValue: defaultValue)
      },
      object: { key, defaultValue in
        return UserDefaults.standard.object(forKey: key.rawValue) ?? defaultValue
      },
      set: { value, key in
        UserDefaults.standard.set(value, forKey: key.rawValue)
      },
      removeObject: { key in
        UserDefaults.standard.removeObject(forKey: key.rawValue)
      },
      reset: {
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
          if key != UserDefaultsKey.isFirstLaunch.rawValue {
            UserDefaults.standard.removeObject(forKey: key.description)
          }
        }
      }
    )
  }
}
