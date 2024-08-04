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
  case appleLogin(idToken: String)
  case regenerateToken(refreshToken: String)
}

extension AuthEndpoint: BaseTargetType {
  var path: String {
    switch self {
    case .kakaoLogin:
      return "/auth/kakao-login"
    case .appleLogin:
      return "/auth/apple-login"
    case .regenerateToken:
      return "/auth/regenerate-token"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .kakaoLogin, .appleLogin, .regenerateToken:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .kakaoLogin(request):
      return .requestJSONEncodable(request)
      
    case let .appleLogin(idToken):
      return .requestParameters(parameters: [
        "idToken" : idToken
      ], encoding: JSONEncoding.default)
      
    case .regenerateToken:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case let .regenerateToken(refreshToken):
      return [
        "Content-type":"application/json",
        "Authorization": refreshToken
      ]
      
    default:
      return ["Content-type":"application/json"]
    }
  }
}
