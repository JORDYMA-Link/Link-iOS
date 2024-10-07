//
//  Summary.swift
//  Models
//
//  Created by kyuchul on 8/16/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct Summary: Equatable {
  public let title: String
  public let summary: String
  public let source: String
  public let sourceUrl: String
  public let keywords: [String]
  public let recommend: String
  public let folders: [String]
  
  public init(
    title: String,
    summary: String,
    source: String,
    sourceUrl: String,
    keywords: [String],
    recommend: String,
    folders: [String]
  ) {
    self.title = title
    self.summary = summary
    self.source = source
    self.sourceUrl = sourceUrl
    self.keywords = keywords
    self.recommend = recommend
    self.folders = folders
  }
}

extension Summary {
  public static func makeSummaryMock() -> Summary {
    return .init(title: "제목 텍스트", summary: "본문 텍스트 텍스트", source: "브런치", sourceUrl: "브런치 이미지 url", keywords: ["Design System", "디자인", "UX"], recommend: "이더리움", folders: ["디자인", "미분류", "회사"])
  }
}


