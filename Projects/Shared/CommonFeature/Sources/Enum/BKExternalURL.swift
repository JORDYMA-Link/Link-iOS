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
      return "https://daffy-sandal-6ef.notion.site/4df567ac571948f0a2b7d782bde3767a?pvs=4"
    case .termOfUse:
      return "https://daffy-sandal-6ef.notion.site/ea068d8517af4ca0a719916f7d23dee2?pvs=4"
    case .introduceService:
      return "https://daffy-sandal-6ef.notion.site/100-5d76361912514364864547cbc1600531?pvs=4"
    }
  }
  public var url: URL {
    return URL(string: self.urlString)!
  }
}
