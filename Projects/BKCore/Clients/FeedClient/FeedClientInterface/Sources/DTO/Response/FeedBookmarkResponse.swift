//
//  FeedBookmarkResponse.swift
//  Services
//
//  Created by kyuchul on 8/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKModel

public struct FeedBookmarkResponse: Decodable {
  let id: Int
  let isMarked: Bool
  let modifiedDate: String
}

public extension FeedBookmarkResponse {
  func toDomain() -> FeedBookmark {
    return FeedBookmark(
      feedId: id,
      isMarked: isMarked,
      modifiedDate: modifiedDate
    )
  }
}
