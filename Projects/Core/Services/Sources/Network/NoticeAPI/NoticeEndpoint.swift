//
//  NoticeEndpoint.swift
//  Models
//
//  Created by 문정호 on 8/26/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Moya

enum NoticeEndpoint {
  case getNotice(page: Int, size: Int)
}

extension NoticeEndpoint: BaseTargetType {
  var path: String {
    switch self {
    case .getNotice:
      return "/notice"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getNotice:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .getNotice(page, size):
      return .requestParameters(parameters: ["page": page, "size": size], encoding: URLEncoding.queryString)
    }
  }
}
