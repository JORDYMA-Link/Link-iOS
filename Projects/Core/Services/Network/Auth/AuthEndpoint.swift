//
//  AuthEndpoint.swift
//  Services
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Moya

enum AuthEndpoint {
  case kakaoLogin(request: KakaoLoginRequest)
  
}

extension AuthEndpoint: BaseTargetType {
  var path: String {
    switch self {
    case .kakaoLogin:
      return "/auth/kakao-login"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .kakaoLogin:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .kakaoLogin(request):
      return .requestJSONEncodable(request)
    }
  }
}
