//
//  FeedEndpoint.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Moya

enum FeedEndpoint {
  case getFeed(feedId: Int)
}

extension FeedEndpoint: BaseTargetType {
  var path: String {
    let baseFeedRoutePath: String = "/api/feeds"
    
    switch self {
    case let .getFeed(feedId):
      return baseFeedRoutePath + "/\(feedId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .getFeed:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .getFeed(feedId):
      return .requestParameters(parameters: [
        "feedId": feedId
      ], encoding: URLEncoding.default)
    }
  }
}
