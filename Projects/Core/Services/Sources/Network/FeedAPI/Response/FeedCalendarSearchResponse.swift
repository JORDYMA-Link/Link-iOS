//
//  CalendarSearchResponse.swift
//  Services
//
//  Created by 문정호 on 9/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

// MARK: - FeedCalendarSearchResponse
struct FeedCalendarSearchResponse: Decodable {
  let monthlyFeedMap: [String: DaysInfoResponse]
}

// MARK: - DaysInfo
struct DaysInfoResponse: Decodable {
    let isArchived: Bool
    let list: [ListResponse]
}

// MARK: - List
struct ListResponse: Decodable {
    let folderID: Int
    let folderName: String
    let feedID: Int
    let title, summary, platform, platformImage: String
    let isMarked: Bool
    let keywords: [String]

    enum CodingKeys: String, CodingKey {
        case folderID = "folderId"
        case folderName
        case feedID = "feedId"
        case title, summary, platform, platformImage, isMarked, keywords
    }
}

extension FeedCalendarSearchResponse {
  func toDomain() -> SearchCalendar {
    let existedFeed = self.monthlyFeedMap
      .filter({ !$0.value.list.isEmpty })
      .map({ (key, value) in
        return ((key.toDate(from: "YYYY-MM-dd") ?? Date()) + 32400, value.toDomain())
      })
    
    return SearchCalendar(currentMonthData: Dictionary(uniqueKeysWithValues: existedFeed))
  }
}

extension DaysInfoResponse {
  func toDomain() -> DayInfo {
    DayInfo(
      isArchived: self.isArchived,
      list: self.list.map({ $0.toDomain() })
    )
  }
}

extension ListResponse {
  func toDomain() -> FeedCard {
    FeedCard(
      feedId: self.feedID,
      title: self.title,
      summary: self.summary,
      platform: self.platform,
      platformImage: self.platformImage,
      isMarked: self.isMarked,
      isUnclassified: false,
      keywords: self.keywords,
      recommendedFolder: [],
      folderId: self.folderID,
      folderName: self.folderName
    )
  }
}


