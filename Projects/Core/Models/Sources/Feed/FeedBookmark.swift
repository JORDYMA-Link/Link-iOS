//
//  FeedBookmark.swift
//  Services
//
//  Created by kyuchul on 8/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct FeedBookmark: Equatable {
  let feedId: Int
  let isMarked: Bool
  let modifiedDate: String
  
  public init(
    feedId: Int,
    isMarked: Bool,
    modifiedDate: String
  ) {
    self.feedId = feedId
    self.isMarked = isMarked
    self.modifiedDate = modifiedDate
  }
}
