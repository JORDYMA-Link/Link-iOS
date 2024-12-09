//
//  APIKey.swift
//  CoreKit
//
//  Created by kyuchul on 6/17/24.
//  Copyright © 2024 com.jordyma.blink. All rights reserved.
//

import Foundation

enum APIKey {
    static let kakao = getInfoValue(for: "KAKAO_NATIVE_APP_KEY")
    static let googleAdUnitID = getInfoValue(for: "GOOGLE_AD_UNITID")
    
    private static func getInfoValue(for key: String) -> String {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let value = infoDictionary[key] as? String else {
            fatalError("Wrong \(key)")
        }
        return value
    }
}
