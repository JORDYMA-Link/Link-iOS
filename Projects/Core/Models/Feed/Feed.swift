//
//  Feed.swift
//  Services
//
//  Created by kyuchul on 8/21/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct Feed: Equatable {
  public let feedId: Int
  public let thumnailImage: String
  public let title: String
  public let date: String
  public let summary: String
  public let keywords: [String]
  public let folderName: String
  public let memo: String
  
  public init(
    feedId: Int,
    thumnailImage: String,
    title: String,
    date: String,
    summary: String,
    keywords: [String],
    folderName: String,
    memo: String
  ) {
    self.feedId = feedId
    self.thumnailImage = thumnailImage
    self.title = title
    self.date = date
    self.summary = summary
    self.keywords = keywords
    self.folderName = folderName
    self.memo = memo
  }
}
