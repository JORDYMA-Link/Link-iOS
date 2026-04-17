//
//  WebViewInfo.swift
//  Models
//
//  Created by 김규철 on 3/16/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct WebViewInfo: Equatable {
  public var flag: Bool
  public let link: String
  
  public init(flag: Bool, link: String) {
    self.flag = flag
    self.link = link
  }
}
