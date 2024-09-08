//
//  SettingEndpoint.swift
//  Models
//
//  Created by 문정호 on 8/25/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Moya

enum SettingEndpoint {
  case getUserProfile
  case patchUserProfile(nickName: String)
}

extension SettingEndpoint: BaseTargetType {
  var path: String {
    switch self {
    case .getUserProfile, .patchUserProfile:
      return "/user/profile"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getUserProfile:
      return .get
    case .patchUserProfile:
      return .patch
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .patchUserProfile(nickName):
      return .requestJSONEncodable(UserProfileRequest(nickName: nickName))
    default:
      return .requestPlain
    }
  }
}

