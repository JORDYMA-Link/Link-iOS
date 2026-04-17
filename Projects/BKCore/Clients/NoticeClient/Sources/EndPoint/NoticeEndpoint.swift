//
//  NoticeEndpoint.swift
//  Models
//
//  Created by 문정호 on 8/26/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKNetworkClient
import Moya

enum NoticeEndpoint {
  case getNotice(page: Int, size: Int)
  case getWebViewInfo
}

extension NoticeEndpoint: BaseTargetType {
  var path: String {
    let baseLinkRoutePath: String = "/notice"
    
    switch self {
    case .getNotice:
      return baseLinkRoutePath
    case .getWebViewInfo:
      return baseLinkRoutePath + "/webview"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getNotice, .getWebViewInfo:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .getNotice(page, size):
      return .requestParameters(parameters: ["page": page, "size": size], encoding: URLEncoding.queryString)
    
    case .getWebViewInfo:
      return .requestPlain
    }
  }
}
