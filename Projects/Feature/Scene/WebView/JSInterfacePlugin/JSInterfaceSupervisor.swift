//
//  JSInterfaceSupervisor.swift
//  Feature
//
//  Created by kyuchul on 3/5/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import WebKit

// Plugin을 관리하는 Supervisor
// 웹뷰로부터 특정 Action을 수행 요청을 받으면 Plugin의 callAsAction을 호출하도록 하는 기능을 구현
final class JSInterfaceSupervisor {
  var loadedPlugins = [String: JSInterfacePluggable]()
  
  init() {}
}

extension JSInterfaceSupervisor {
  fileprivate func loadPlugin(_ plugin: JSInterfacePluggable) {
    for action in plugin.actions {
      guard loadedPlugins[action] == nil else {
        assertionFailure("\(action) action already exists. Please check the plugin.")
        return
      }
      loadedPlugins[action] = plugin
    }
  }
  
  func loadPlugin(contentsOf newElements: [JSInterfacePluggable]) {
    newElements.forEach { loadPlugin($0) }
  }
}

extension JSInterfaceSupervisor {
  /// Supervisor에게 Action을 수행 요청
  func resolve(_ action: String, message: [String: Any], with webView: WKWebView) {
    guard let plugin = loadedPlugins[action] else {
      assertionFailure("Failed to resolve \(action): Action is not loaded. Please ensure the plugin is correctly loaded.")
      return
    }
    
    plugin.callAsAction(action, message: message, with: webView)
  }
}
