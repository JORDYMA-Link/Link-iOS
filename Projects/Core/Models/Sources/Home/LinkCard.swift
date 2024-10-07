//
//  LinkCard.swift
//  CoreKit
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct LinkCard: Hashable, Identifiable {
  public var id: Int
  public var sourceTitle: String
  public var sourceImage: String
  public var title: String
  public var description: String
  public var keyword: [String]
  
  public init(id: Int, sourceTitle: String, sourceImage: String, title: String, description: String, keyword: [String]) {
    self.id = id
    self.sourceTitle = sourceTitle
    self.sourceImage = sourceImage
    self.title = title
    self.description = description
    self.keyword = keyword
  }
}

extension LinkCard {
  public static func mock() -> [LinkCard] {
    return [
      .init(id: 1, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
      .init(id: 2, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
      .init(id: 3, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
      .init(id: 4, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
      .init(id: 5, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
      .init(id: 6, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
      .init(id: 7, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
      .init(id: 8, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
      .init(id: 9, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
      .init(id: 10, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
      .init(id: 11, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
      .init(id: 12, sourceTitle: "미디엄", sourceImage: "Image", title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"]),
    ]
  }
}
