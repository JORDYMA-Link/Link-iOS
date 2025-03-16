//
//  BKWebViewBridge.swift
//  Feature
//
//  Created by kyuchul on 3/5/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import Foundation

enum BKWebViewBridge {
  case `default`
  
  var bridgeName: String {
    switch self {
    case .default:
      return (Bundle.main.infoDictionary?["WEB_VIEW_DEFAULT_BRIDGE"] as? String) ?? ""
    }
  }
}
