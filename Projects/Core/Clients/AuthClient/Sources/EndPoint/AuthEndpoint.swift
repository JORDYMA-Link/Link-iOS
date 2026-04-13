//
//  AuthEndpoint.swift
//  Services
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKNetwork
import Moya

enum AuthEndpoint {
  case kakaoLogin(request: KakaoLoginRequest)
  case appleLogin(idToken: String)
  case googleLogin(idToken: String)
  case regenerateToken(refreshToken: String)
  case logout(refreshToken: String)
  case signout(refreshToken: String)
}

extension AuthEndpoint: BaseTargetType {
  var path: String {
    switch self {
    case .kakaoLogin:
      return "/auth/kakao-login"
    case .appleLogin:
      return "/auth/apple-login"
    case .googleLogin:
      return "/auth/google-login"
    case .regenerateToken:
      return "/auth/regenerate-token"
    case .logout:
      return "/auth/logout"
    case .signout:
      return "/auth/signout"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .kakaoLogin, .appleLogin, .googleLogin, .regenerateToken, .logout, .signout:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .kakaoLogin(request):
      return .requestJSONEncodable(request)
      
    case let .googleLogin(idToken):
      let request = TokenRequest(idToken: idToken)
      return .requestJSONEncodable(request)
      
    case let .appleLogin(idToken):
      return .requestParameters(parameters: [
        "idToken" : idToken
      ], encoding: JSONEncoding.default)
      
    case .regenerateToken, .logout, .signout:
      return .requestPlain
    }
  }
  
  var headers: [String : String]? {
    switch self {
    case let .regenerateToken(refreshToken), let .logout(refreshToken), let .signout(refreshToken):
      return [
        "Content-type":"application/json",
        "Authorization": "Bearer \(refreshToken)"
      ]
      
    default:
      return ["Content-type":"application/json"]
    }
  }
}
