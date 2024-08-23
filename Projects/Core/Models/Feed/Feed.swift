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
  public let folderName: String
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

extension Feed {
  public static func mock() -> Feed {
    return Feed(feedId: 2, thumnailImage: "https://jordyma-dev.s3.ap-northeast-2.amazonaws.com/thumbnail/2_b40e41e8-f37d-4939-bd39-20af9658f9f3_image%20%281%29.png", platformImage: "", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", date: "2024.09.01", summary: "The problem is not with KFImage, which is loading as expected, but with the fact that TabView", keywords: ["Design System", "디자인", "UI/UX"], folderName: "디자인", recommendFolders: ["ggg", "aaaa", "azzz"], memo: "", isMarked: true, originUrl: "www.naver.com")
  }
}
