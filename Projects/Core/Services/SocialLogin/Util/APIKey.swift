//
//  APIKey.swift
//  CoreKit
//
//  Created by kyuchul on 6/17/24.
//  Copyright © 2024 com.jordyma.blink. All rights reserved.
//

import Foundation

enum APIKey {
  static let kakao = {
        guard let infoDictionary = Bundle.main.infoDictionary else { fatalError("Wrong Info dictionary") }
        guard let key = infoDictionary["KAKAO_NATIVE_APP_KEY"] as? String else { fatalError("Wrong KAKAO_NATIVE_APP_KEY") }
        return key
    }()
}
