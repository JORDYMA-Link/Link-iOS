//
//  SearchCalendar.swift
//  Services
//
//  Created by 문정호 on 9/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

// MARK: - FeedCalendarSearchResponse
public struct SearchCalendar {
  let currentMonthData: [String: DaysInfo]
  
  public init(
    currentMonthData: [String : DaysInfo]
  ) {
    self.currentMonthData = currentMonthData
  }
}

// MARK: - DaysInfo
public struct DaysInfo {
    let isArchived: Bool
    let list: [List]
  
  public init(
    isArchived: Bool,
    list: [List]
  ) {
    self.isArchived = isArchived
    self.list = list
  }
}

// MARK: - List
public struct List {
    let folderID: Int
    let folderName: String
    let feedID: Int
    let title, summary, platform, platformImage: String
    let isMarked: Bool
    let keywords: [String]
  
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
