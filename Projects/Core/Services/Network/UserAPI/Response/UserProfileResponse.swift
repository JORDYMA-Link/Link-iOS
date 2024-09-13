//
//  UserProfileResponse.swift
//  Models
//
//  Created by 문정호 on 8/25/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

struct UserProfileResponse: Decodable {
  let nickName: String
}

extension UserProfileResponse {
  public func toDomain() -> Setting {
    return Setting(
      nickname: nickName
    )
  }
}
