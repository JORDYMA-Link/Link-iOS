//
//  SaveChallengeJSPlugin.swift
//  Feature
//
//  Created by 김규철 on 7/13/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import WebKit

class SaveChallengeJSPlugin: JSInterfacePluggable {
  let actions = [
    SaveChallengeJSAction.closeSaveChallengeModalKey,
    SaveChallengeJSAction.joinSaveChallengeChallengeKey
  ]
  
  func callAsAction(_ action: String, message: [String: Any], with webView: WKWebView) {
    guard let action = SaveChallengeJSAction(fromRawValue: action, message: message) else { return }
    
    closure?(action, webView)
  }
  
  func set(_ closure: @escaping (SaveChallengeJSAction, WKWebView) -> Void) {
    self.closure = closure
  }

  private var closure: ((SaveChallengeJSAction, WKWebView) -> Void)?
}

extension SaveChallengeJSPlugin {
  enum SaveChallengeJSAction {
    case closeSaveChallengeModal
    case joinSaveChallengeChallenge
        
    init?(fromRawValue: String, message: [String: Any]) {
      switch fromRawValue {
      case "closeSaveChallengeModal":
        self = .closeSaveChallengeModal
        
      case "joinSaveChallengeChallenge":
        self = .joinSaveChallengeChallenge
        
      default:
        return nil
      }
    }
    
    static let closeSaveChallengeModalKey = "closeSaveChallengeModal"
    static let joinSaveChallengeChallengeKey = "joinSaveChallengeChallenge"
  }
}
