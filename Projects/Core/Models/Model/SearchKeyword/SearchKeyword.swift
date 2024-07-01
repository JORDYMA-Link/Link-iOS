//
//  SearchKeyword.swift
//  CoreKit
//
//  Created by kyuchul on 6/27/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct SearchKeywordSection: Equatable, Identifiable {
  public let id = UUID()
  public let searchList: [SearchKeyword]
  public var isSeeMoreButtonHidden = false
  
  public init(searchList: [SearchKeyword]) {
    self.searchList = searchList
  }
}

public struct SearchKeyword: Equatable, Identifiable {
  public var id = UUID()
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
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 11, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 12, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 13, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 14, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 15, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 16, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 17, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 18, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 19, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 20, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 21, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 22, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 23, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: false, keywords: ["Design System", "디자인", "UX"]),
            SearchKeyword(date: "2024-06-01", folderId: 1, folderName: "디자인", feedId: 24, title: "제목 텍스트", summary: "본문 텍스트 두줄 텍스트", source: "브런치", sourceUrl: "", isMarked: true, keywords: ["Design System", "디자인", "UX"])
    ]
  }
}


