//
//  UserProfileEncodable.swift
//  Models
//
//  Created by 문정호 on 8/26/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct UserProfileRequest: Encodable {
  private let nickname: String
  
  init(nickName: String) {
    self.nickname = nickName
  }
}
