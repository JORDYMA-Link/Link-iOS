//
//  FeedChallenge.swift
//  Models
//
//  Created by kyuchul on 3/16/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct FeedChallenge: Equatable {
  public let isVisible: Bool
  public let count: Int
  
  public init(
    isVisible: Bool,
    count: Int
  ) {
    self.isVisible = isVisible
    self.count = count
  }
} 