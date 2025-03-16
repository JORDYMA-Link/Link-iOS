//
//  SurveyJSPlugin.swift
//  Feature
//
//  Created by kyuchul on 3/5/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import WebKit

class SurveyJSPlugin: JSInterfacePluggable {
  let actions = [
    SurveyJSAction.closeSurveyModalKey,
    SurveyJSAction.openSurveyFormKey
  ]
  
  func callAsAction(_ action: String, message: [String: Any], with webView: WKWebView) {
    guard let action = SurveyJSAction(fromRawValue: action, message: message) else { return }
    
    closure?(action, webView)
  }
  
  func set(_ closure: @escaping (SurveyJSAction, WKWebView) -> Void) {
    self.closure = closure
  }

  private var closure: ((SurveyJSAction, WKWebView) -> Void)?
}

extension SurveyJSPlugin {
  enum SurveyJSAction {
    case closeSurveyModal
    case openSurveyForm(url: String)
        
    init?(fromRawValue: String, message: [String: Any]) {
      switch fromRawValue {
      case "closeSurveyModal":
        self = .closeSurveyModal
        
      case "openSurveyForm":
        guard let url = message["formUrl"] as? String else { return nil }
        self = .openSurveyForm(url: url)
        
      default:
        return nil
      }
    }
    
    static let closeSurveyModalKey = "closeSurveyModal"
    static let openSurveyFormKey = "openSurveyForm"
  }
}
