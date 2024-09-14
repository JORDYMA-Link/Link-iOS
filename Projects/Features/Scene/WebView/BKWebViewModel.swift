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
  /// 타이틀 URL
  @Published var title: String = ""
  /// 뒤로가기 가능 여부
  @Published var canGoBack: Bool = false
  /// 앞으로가기 가능 여부
  @Published var canGoForward: Bool = false
  /// 웹뷰 로딩
  @Published var isLoading: Bool = true
  /// ActivityViewPresented
  @Published var isActivityViewPresented: Bool = false
  
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

