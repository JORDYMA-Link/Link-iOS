//
//  BaseTargetType.swift
//  CoreKit
//
//  Created by kyuchul on 6/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Moya

public protocol BaseTargetType: TargetType {}

public extension BaseTargetType {
  var baseURL: URL {
    guard
      let urlString = Bundle.main.infoDictionary?["BASE_URL"] as? String,
      let targetURL = URL(string: urlString)
    else {
      fatalError("BaseURL을 생성할 수 없습니다.")
    }
    return targetURL
  }
  
  var headers: [String : String]? {
    return ["Content-type":"application/json"]
  }
  
  var validationType: ValidationType {
    return .successCodes
  }
}


