//
//  LinkDetail.swift
//  CoreKit
//
//  Created by kyuchul on 7/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct LinkDetail: Hashable {
  public let feedId: Int
  public let thumnailImage: String
  public let title: String
  public let date: String
  public let summary: String
  public let keywords: [String]
  public let folderName: String
  public let memo: String
  
  public init(feedId: Int, thumnailImage: String, title: String, date: String, summary: String, keywords: [String], folderName: String, memo: String) {
    self.feedId = feedId
    self.thumnailImage = thumnailImage
    self.title = title
    self.date = date
    self.summary = summary
    self.keywords = keywords
    self.folderName = folderName
    self.memo = memo
  }
}

extension LinkDetail {
  public static func mock() -> LinkDetail {
    return .init(feedId: 123, thumnailImage: "", title: "32세, 6년만에 1000억을 번 알렉스 홀모지의 레버리지 극대화 방법 당신은 어떤 문화에서 성장하고 있나요?", date:  "2024-06-01", summary: "본문 텍스트입니다. 걱정하지 마세요. 지난 22일 러시아 모스크바 시내 공연장에서 발생한 총기 난사 사건 사망자가 지난 22일 러시아 모스크바 시내 공연장에서 발생한 총기 난사 사건 사망자가", keywords: ["Design System", "디자인", "UX"], folderName: "이더리움", memo: "메모메메메메ㅔ메메메모")
  }
}

