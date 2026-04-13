//
//  UserEndpoint.swift
//  Models
//
//  Created by 문정호 on 8/25/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKNetwork

import BKNetwork
import Moya

enum UserEndpoint {
  case getUserProfile
  case patchUserProfile(nickName: String)
  case putFcmPushToken(pushTokenType: String = "IOS", pushToken: String)
  case postOnboarding(jobField: String, birthYear: String, gender: String)
}

extension UserEndpoint: BaseTargetType {
  var path: String {
    let baseUserRoutePath: String = "/user"
    
    switch self {
    case .getUserProfile, .patchUserProfile:
      return baseUserRoutePath + "/profile"
    case .putFcmPushToken:
      return baseUserRoutePath + "/push-token"
    case .postOnboarding:
      return baseUserRoutePath + "/onboarding"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getUserProfile:
      return .get
    case .patchUserProfile:
      return .patch
    case .putFcmPushToken:
      return .put
    case .postOnboarding:
      return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
    case .getUserProfile:
      return .requestPlain
      
    case let .patchUserProfile(nickName):
      return .requestJSONEncodable(UserProfileRequest(nickName: nickName))
      
    case let .putFcmPushToken(pushTokenType, pushToken):
      return .requestParameters(
        parameters: [
          "pushTokenType" : pushTokenType,
          "pushToken" : pushToken
        ],
        encoding: JSONEncoding.default)
        
    case let .postOnboarding(jobField, birthYear, gender):
      return .requestJSONEncodable(OnboardingRequest(
        jobField: jobField,
        birthYear: birthYear,
        gender: gender
      ))
    }
  }
}

