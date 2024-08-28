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
  case postFeedMemo(feedId: Int, memo: String)
  case getFeed(feedId: Int)
}

extension FeedEndpoint: BaseTargetType {
  var path: String {
    let baseFeedRoutePath: String = "/api/feeds"
    
    switch self {
    case .postFeedMemo:
      return baseFeedRoutePath + "/memo"
    case let .getFeed(feedId):
      return baseFeedRoutePath + "/detail/\(feedId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .postFeedMemo:
      return .post
    case .getFeed:
      return .get
    }
  }
  
  var task: Moya.Task {
    switch self {
    case let .postFeedMemo(feedId, memo):
      return .requestParameters(parameters: [
        "feedId": feedId,
        "memo": memo
      ], encoding: JSONEncoding.default)
      
    case let .getFeed(feedId):
      return .requestParameters(parameters: [
        "feedId": feedId
      ], encoding: URLEncoding.default)
    }
  }
}
