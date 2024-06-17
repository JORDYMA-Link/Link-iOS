//
//  UserDefaultsClient.swift
//  Util
//
//  Created by kyuchul on 6/8/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation
import ComposableArchitecture

public struct UserDefaultsClient {
    public enum UserDefaultsKey: String {
        case isFirstLanch
    }
    
    public var string: @Sendable (_ forKey: UserDefaultsKey) -> String?
    public var integer: @Sendable (_ forKey: UserDefaultsKey) -> Int?
    public var bool: @Sendable (_ forKey: UserDefaultsKey) -> Bool?
    public var float: @Sendable (_ forKey: UserDefaultsKey) -> Float?
    public var double: @Sendable (_ forKey: UserDefaultsKey) -> Double?
    public var data: @Sendable (_ forKey: UserDefaultsKey) -> Data?
    public var object: @Sendable (_ forKey: UserDefaultsKey) -> Any?
    public var set: @Sendable (_ value: Any, _ forKey: UserDefaultsKey) -> Void
    public var removeObject: @Sendable (_ forKey: UserDefaultsKey) -> Void
    
    public func codableObject<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            print("Failed to decode \(type) from UserDefaults with key \(key): \(error)")
            return nil
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

extension UserDefaultsClient: DependencyKey {
    static func getUserDefaultsObject<T>(_ type: T.Type, forKey key: String) -> T? {
        let value = UserDefaults.standard.object(forKey: key) as? T
        return value
    }
    
    public static var liveValue: UserDefaultsClient {
        return Self(
            string: { key in
                return getUserDefaultsObject(String.self, forKey: key.rawValue)
            },
            integer: { key in
                return getUserDefaultsObject(Int.self, forKey: key.rawValue)
            },
            bool: { key in
                return getUserDefaultsObject(Bool.self, forKey: key.rawValue)
            },
            float: { key in
                return getUserDefaultsObject(Float.self, forKey: key.rawValue)
            },
            double: { key in
                return getUserDefaultsObject(Double.self, forKey: key.rawValue)
            },
            data: { key in
                return getUserDefaultsObject(Data.self, forKey: key.rawValue)
            },
            object: { key in
                return UserDefaults.standard.object(forKey: key.rawValue)
            },
            set: { value, key in
                return UserDefaults.standard.set(value, forKey: key.rawValue)
            },
            removeObject: { key in
                UserDefaults.standard.removeObject(forKey: key.rawValue)
            }
        )
    }
}

public extension DependencyValues {
    var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}
