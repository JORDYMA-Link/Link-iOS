//
//  FeedChallengeResponse.swift
//  Services
//
//  Created by kyuchul on 3/16/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKModel

public struct FeedChallengeResponse: Decodable {
  private let isVisible: Bool
  private let count: Int
  
  init(
    isVisible: Bool,
    count: Int
  ) {
    self.isVisible = isVisible
    self.count = count
  }
}

public extension FeedChallengeResponse {
  func toDomain() -> FeedChallenge {
    return FeedChallenge(
      isVisible: isVisible,
      challengeType: FeedChallengeType(rawValue: count) ?? .error
    )
  }
}
