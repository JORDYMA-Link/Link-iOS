//
//  URL+.swift
//  Common
//
//  Created by kyuchul on 12/24/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public enum URLLiteral {
  case privacy
  case termOfUse
  case introduceService
  case appStore
  case custom(String)
}

extension URLLiteral {
  public var url: URL? {
    switch self {
    case .privacy:
      return URL(string:"https://daffy-sandal-6ef.notion.site/fb6f49c6bd714097a422c39d5047e7f5")
    case .termOfUse:
      return URL(string:"https://daffy-sandal-6ef.notion.site/c784f55ca8164c669845d3569cd6683a")
    case .introduceService:
      return URL(string:"https://daffy-sandal-6ef.notion.site/6addddc3f4164264b4fc58d01cbfd706?pvs=4")
    case .appStore:
      return URL(string:"https://apps.apple.com/kr/app/ai-%EB%A7%81%ED%81%AC-%EC%95%84%EC%B9%B4%EC%9D%B4%EB%B9%99-%EB%B8%94%EB%A7%81%ED%81%AC/id6605930254")
    case let .custom(urlString):
      return URL(string: urlString)
    }
  }
}
