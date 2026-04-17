//
//  SearchFeed.swift
//  Services
//
//  Created by kyuchul on 8/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct SearchFeed: Equatable, Identifiable {
  public let id = UUID()
  public let query: String
  public var result: [FeedCard]
  public var isPagination: Bool = true
  public var isLast: Bool = false
  
  public init(
    query: String,
    result: [FeedCard]
  ) {
    self.query = query
    self.result = result
  }
}
