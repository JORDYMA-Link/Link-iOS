//
//  Feed.swift
//  Services
//
//  Created by kyuchul on 8/21/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

// 추후 요약하기 response 관련 수정 필요
public struct Feed: Equatable {
  public let feedId: Int
  public let thumnailImage: String
  public let platformImage: String?
  public var title: String
  public let date: String
  public var summary: String
  public var keywords: [String]
  public var folderName: String
  public let recommendFolders: [String]?
  public var memo: String
  public var isMarked: Bool
  public var originUrl: String
  
  public init(
    feedId: Int,
    thumnailImage: String,
    platformImage: String,
    title: String,
    date: String,
    summary: String,
    keywords: [String],
    folderName: String,
    recommendFolders: [String]?,
    memo: String,
    isMarked: Bool,
    originUrl: String
  ) {
    self.feedId = feedId
    self.thumnailImage = thumnailImage
    self.platformImage = platformImage
    self.title = title
    self.date = date
    self.summary = summary
    self.keywords = keywords
    self.folderName = folderName
    self.recommendFolders = recommendFolders
    self.memo = memo
    self.isMarked = isMarked
    self.originUrl = originUrl
  }
}

public extension Feed {
  func toFeedCard(_ initFeedCard: FeedCard) -> FeedCard {
    return FeedCard(
      feedId: initFeedCard.feedId,
      title: title,
      summary: summary,
      platform: initFeedCard.platform,
      platformImage: initFeedCard.platformImage,
      isMarked: isMarked,
      isUnclassified: initFeedCard.isUnclassified,
      keywords: keywords,
      recommendedFolder: initFeedCard.recommendedFolder,
      folderId: initFeedCard.folderId,
      folderName: initFeedCard.folderName
    )
  }
}
