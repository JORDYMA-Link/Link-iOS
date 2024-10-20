//
//  SearchCalendar.swift
//  Services
//
//  Created by 문정호 on 9/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

// MARK: - CalendarSearch
/// 앱 내에서 사용하는 CalendarSearch Model입니다.
///
/// 현재 Network Response는 피드가 존재하지 않는 날짜의 데이터들도 전송하기  때문에 피드가 피드가 존재하는 날짜만 필터링하여 해당 Model을 사용합니다.
public struct SearchCalendar: Equatable {
  public var existedFeedData: [Date: DayInfo]
  
  public init(
    currentMonthData: [Date : DayInfo]
  ) {
    self.existedFeedData = currentMonthData
  }
}

// MARK: - DaysInfo
public struct DayInfo: Equatable {
  public let isArchived: Bool
  public var list: [FeedCard]
  
  public init(
    isArchived: Bool,
    list: [FeedCard]
  ) {
    self.isArchived = isArchived
    self.list = list
  }
}

// MARK: - List
public struct CalendarFeed: Hashable {
  public var folderId: Int
  public var folderName: String
  public let feedId: Int
  public var title, summary, platform, platformImage: String
  public var isMarked: Bool
  public var keywords: [String]
  
  public init(
    folderId: Int,
    folderName: String,
    feedId: Int,
    title: String,
    summary: String,
    platform: String,
    platformImage: String,
    isMarked: Bool,
    keywords: [String]
  ) {
    self.folderId = folderId
    self.folderName = folderName
    self.feedId = feedId
    self.title = title
    self.summary = summary
    self.platform = platform
    self.platformImage = platformImage
    self.isMarked = isMarked
    self.keywords = keywords
  }
}
