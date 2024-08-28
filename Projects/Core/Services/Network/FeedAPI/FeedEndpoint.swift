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
  case deleteFeed(feedId: Int)
  case patchBookmark(feedId: Int, setMarked: Bool)
  case getFeedSearch(query: String, page: Int, size: Int = 10)
  case getFeed(feedId: Int)
}

extension FeedEndpoint: BaseTargetType {
  var path: String {
    let baseFeedRoutePath: String = "/api/feeds"
    
    switch self {
    case .postFeedMemo:
      return baseFeedRoutePath + "/memo"
    case let .deleteFeed(feedId):
      return baseFeedRoutePath + "/\(feedId)"
    case let .patchBookmark(feedId, _):
      return baseFeedRoutePath + "/bookmark/\(feedId)"
    case .getFeedSearch:
      return baseFeedRoutePath + "/search"
    case let .getFeed(feedId):
      return baseFeedRoutePath + "/detail/\(feedId)"
    }
  }
  
  var method: Moya.Method {
    switch self {
    case .postFeedMemo:
      return .post
    case .deleteFeed:
      return .delete
    case .patchBookmark:
      return .patch
    case .getFeed, .getFeedSearch:
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
      
    case let .patchBookmark(_, setMarked):
      return .requestParameters(parameters: [
        "setMarked": setMarked
      ], encoding: URLEncoding.default)
      
    case let .getFeedSearch(query, page, size):
      return .requestParameters(parameters: [
        "query": query,
        "page": page,
        "size": size
      ], encoding: URLEncoding.default)
      
    case .getFeed, .deleteFeed:
      return .requestPlain
    }
  }
}
