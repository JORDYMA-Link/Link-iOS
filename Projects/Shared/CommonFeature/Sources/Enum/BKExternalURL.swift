//
//  BKExternalURL.swift
//  CommonFeature
//
//  Created by 문정호 on 10/13/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public enum BKExternalURL {
  case privacy
  case termOfUse
  case introduceService
}

extension BKExternalURL {
  public var urlString: String {
    switch self {
    case .privacy:
      return "https://daffy-sandal-6ef.notion.site/fb6f49c6bd714097a422c39d5047e7f5"
    case .termOfUse:
      return "https://daffy-sandal-6ef.notion.site/c784f55ca8164c669845d3569cd6683a"
    case .introduceService:
      return "https://daffy-sandal-6ef.notion.site/100-5d76361912514364864547cbc1600531?pvs=4"
    }
  }
  public var url: URL {
    return URL(string: self.urlString)!
  }
}
