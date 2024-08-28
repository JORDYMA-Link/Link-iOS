//
//  SearchFeed.swift
//  Services
//
//  Created by kyuchul on 8/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct SearchFeed: Equatable {
  public let query: String
  public let result: [FeedCard]
  
  public init(
    query: String,
    result: [FeedCard]
  ) {
    self.query = query
    self.result = result
  }
}
