//
//  JSInterfacePluggable.swift
//  Feature
//
//  Created by kyuchul on 3/5/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import WebKit

protocol JSInterfacePluggable {
  // Action을 Key로 사용 -> 여러 Action이 존재할 수 있으므로 [String]
  var actions: [String] { get }
  //  message를 넘겨받을 수 있도록 하는 callAsAction 메소드
  func callAsAction(_ action: String, message: [String: Any], with: WKWebView)
}
