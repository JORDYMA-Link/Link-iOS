//
//  WebViewInfoResponse.swift
//  Services
//
//  Created by 김규철 on 3/16/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

struct WebViewInfoResponse: Decodable {
  let flag: Bool
  let link: String
  
  init(flag: Bool, link: String) {
    self.flag = flag
    self.link = link
  }
}

extension WebViewInfoResponse {
  public func toDomain() -> WebViewInfo {
    return .init(
      flag: flag,
      link: link
    )
  }
}
