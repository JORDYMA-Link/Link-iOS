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
    }
  }
}
