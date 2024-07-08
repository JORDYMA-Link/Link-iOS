//
//  LocalError.swift
//  CommonFeature
//
//  Created by 문정호 on 7/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public enum LocalError: Error {
  case dateError
  
  var description: String {
    switch self {
    case .dateError:
      return "Date 연산에 실패하였습니다."
    }
  }
}
