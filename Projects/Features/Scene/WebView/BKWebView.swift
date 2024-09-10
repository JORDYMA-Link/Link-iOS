//
//  BKWebView.swift
//  Features
//
//  Created by kyuchul on 9/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI
import WebKit

struct BKWebView: UIViewRepresentable {
  private let webView: WKWebView
  private var url: URL
  @ObservedObject var viewModel: BKWebViewModel
  
  init(
    url: URL,
    viewModel: BKWebViewModel
  ) {
    self.url = url
    self.viewModel = viewModel
    webView = WKWebView()
  }
  
  func makeUIView(context: Context) -> WKWebView {
    webView.navigationDelegate = context.coordinator
    viewModel.webView = webView
    let request = URLRequest(url: url)
    webView.load(request)
    return webView
  }
  
  func updateUIView(_ webView: WKWebView, context: Context) {
  }
    
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
}

final class Coordinator: NSObject, WKNavigationDelegate {
  private let parent: BKWebView
  
  init(parent: BKWebView) {
    self.parent = parent
  }
  
  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
      if let urlString = webView.url?.absoluteString {
        self.parent.viewModel.title = urlString
      }
    
    self.parent.viewModel.canGoBack = webView.canGoBack
    self.parent.viewModel.canGoForward = webView.canGoForward
  }
}
