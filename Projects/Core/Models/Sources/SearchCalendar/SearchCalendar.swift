//
//  SearchCalendar.swift
//  Services
//
//  Created by 문정호 on 9/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

// MARK: - FeedCalendarSearchResponse
public struct SearchCalendar: Equatable {
  public let existedFeedData: [Date: DaysInfo]
  
  public init(
    currentMonthData: [Date : DaysInfo]
  ) {
    self.existedFeedData = currentMonthData
  }
}

// MARK: - DaysInfo
public struct DaysInfo: Equatable {
  public let isArchived: Bool
  public let list: [CalendarFeed]
  
  public init(
    isArchived: Bool,
    list: [CalendarFeed]
  ) {
    self.isArchived = isArchived
    self.list = list
  }
}

// MARK: - List
public struct CalendarFeed: Hashable {
  public let folderID: Int
  public let folderName: String
  public let feedID: Int
  public let title, summary, platform, platformImage: String
  public let isMarked: Bool
  public let keywords: [String]
  
  public init(
    folderID: Int,
    folderName: String,
    feedID: Int,
    title: String,
    summary: String,
    platform: String,
    platformImage: String,
    isMarked: Bool,
    keywords: [String]
  ) {
    self.folderID = folderID
    self.folderName = folderName
    self.feedID = feedID
    self.title = title
    self.summary = summary
    self.platform = platform
    self.platformImage = platformImage
    self.isMarked = isMarked
    self.keywords = keywords
  }
}
