//
//  FeedCard.swift
//  Services
//
//  Created by kyuchul on 8/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct FeedCard: Equatable {
  public let feedId: Int
  public let title: String
  public let summary: String
  public let platform: String
  public let platformImage: String
  public let isMarked: Bool
  public let isUnclassified: Bool
  public let keywords: [String]
  public let recommendedFolder: [String]
  public let folderId: Int
  public let folderName: String
  
  public init(
    feedId: Int,
    title: String,
    summary: String,
    platform: String,
    platformImage: String,
    isMarked: Bool,
    isUnclassified: Bool,
    keywords: [String],
    recommendedFolder: [String],
    folderId: Int,
    folderName: String
  ) {
    self.feedId = feedId
    self.title = title
    self.summary = summary
    self.platform = platform
    self.platformImage = platformImage
    self.isMarked = isMarked
    self.isUnclassified = isUnclassified
    self.keywords = keywords
    self.recommendedFolder = recommendedFolder
    self.folderId = folderId
    self.folderName = folderName
  }
}
