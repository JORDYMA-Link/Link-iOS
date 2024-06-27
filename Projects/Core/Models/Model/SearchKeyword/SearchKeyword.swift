//
//  SearchKeyword.swift
//  CoreKit
//
//  Created by kyuchul on 6/27/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct SearchKeyword: Hashable {
  public var date: String
  public var folderId: Int
  public var folderName: String
  public var feedId: Int
  public var title: String
  public var summary: String
  public var source: String
  public var sourceUrl: String
  public var isMarked: Bool
  public var keywords: [String]
  
  public init(date: String, folderId: Int, folderName: String, feedId: Int, title: String, summary: String, source: String, sourceUrl: String, isMarked: Bool, keywords: [String]) {
    self.date = date
    self.folderId = folderId
    self.folderName = folderName
    self.feedId = feedId
    self.title = title
    self.summary = summary
    self.source = source
    self.sourceUrl = sourceUrl
    self.isMarked = isMarked
    self.keywords = keywords
  }
}

extension SearchKeyword {
  public static func mock() -> [SearchKeyword] {
    return [SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 10, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"])
    ]
  }
}


