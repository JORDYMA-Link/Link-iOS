//
//  SearchFeedResponse.swift
//  Services
//
//  Created by kyuchul on 8/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKModel

struct SearchFeedResponse: Decodable {
  let query: String
  let result: [FeedCardResponse]
}

extension SearchFeedResponse {
  func toDomain() -> SearchFeed {
    return SearchFeed(
      query: query,
      result: result.map { $0.toDomain() }
    )
  }
}
