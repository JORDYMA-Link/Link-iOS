//
//  FeedResponse.swift
//  Services
//
//  Created by kyuchul on 8/21/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

struct FeedResponse: Decodable {
  let feedId: Int
  let thumnailImage: String
  let title: String
  let date: String
  let summary: String
  let keywords: [String]
  let folderName: String
  let memo: String
}

extension FeedResponse {
  func toDomain() -> Feed {
    Feed(
      feedId: feedId,
      thumnailImage: thumnailImage,
      title: title,
      date: date,
      summary: summary,
      keywords: keywords,
      folderName: folderName,
      memo: memo
    )
  }
}
