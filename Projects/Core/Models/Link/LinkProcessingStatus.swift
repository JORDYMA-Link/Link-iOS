//
//  LinkProcessingStatus.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct LinkProcessingStatus: Equatable {
  public let feedId: Int
  public let title: String
  public let status: String
  
  public init(
    feedId: Int,
    title: String,
    status: String
  ) {
    self.feedId = feedId
    self.title = title
    self.status = status
  }
}
