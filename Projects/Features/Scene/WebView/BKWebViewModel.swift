//
//  BKWebViewModel.swift
//  Features
//
//  Created by kyuchul on 9/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI
import WebKit

final class BKWebViewModel: ObservableObject {
  @Published var title: String = ""
  @Published var canGoBack = false
  @Published var canGoForward = false
  
  var webView: WKWebView?
  
  func goBack() {
    if canGoBack {
      webView?.goBack()
    }
  }
  
  func goForward() {
    if canGoForward {
      webView?.goForward()
    }
  }
  
  func reload() {
    webView?.reload()
  }
}

