//
//  FeedCardResponse.swift
//  Services
//
//  Created by kyuchul on 8/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

struct FeedCardResponse: Decodable {
  let feedId: Int
  let title: String
  let summary: String
  let platform: String
  let platformImage: String
  let isMarked: Bool
  let isUnclassified: Bool?
  let keywords: [String]
  let recommendedFolder: [String]?
  let folderId: Int?
  let folderName: String?
}

extension FeedCardResponse {
  func toDomain() -> FeedCard {
    return FeedCard(
      feedId: feedId,
      title: title,
      summary: summary,
      platform: platform,
      platformImage: platformImage,
      isMarked: isMarked,
      isUnclassified: isUnclassified ?? false,
      keywords: keywords,
      recommendedFolder: recommendedFolder ?? [],
      folderId: folderId ?? 0,
      folderName: folderName ?? ""
    )
  }
}
