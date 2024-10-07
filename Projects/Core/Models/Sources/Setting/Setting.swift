//
//  Setting.swift
//  Models
//
//  Created by 문정호 on 8/25/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct Setting: Equatable {
  public var nickname: String
  
  public init(nickname: String) {
    self.nickname = nickname
  }
}
