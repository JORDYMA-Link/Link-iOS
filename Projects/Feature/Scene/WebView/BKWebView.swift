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
  @ObservedObject var viewModel: BKWebViewModel
  private var url: URL
  private let webView: WKWebView
  private let isScrollEnabled: Bool
  private let webAction: ((BKWebViewAction) -> ())?
  private let supervisor = JSInterfaceSupervisor()
  
  init(
    viewModel: BKWebViewModel,
    url: URL,
    isScrollEnabled: Bool = true,
    webAction: ((BKWebViewAction) -> ())? = nil
  ) {
    self.viewModel = viewModel
    self.url = url
    self.isScrollEnabled = isScrollEnabled
    let preferences = WKPreferences()
    preferences.javaScriptCanOpenWindowsAutomatically = true
    let configuration = WKWebViewConfiguration()
    configuration.preferences = preferences
    configuration.defaultWebpagePreferences.allowsContentJavaScript = true
    webView = WKWebView(frame: .zero, configuration: configuration)
    self.webAction = webAction
  }
  
  func makeUIView(context: Context) -> WKWebView {
    webView.configuration.userContentController.add(
      context.coordinator,
      name: BKWebViewBridge.default.bridgeName
    )
    webView.scrollView.isScrollEnabled = isScrollEnabled
    webView.navigationDelegate = context.coordinator
    viewModel.webView = webView
    let request = URLRequest(url: url)
    webView.load(request)
    
    initPlugins()
    
    return webView
  }
  
  func updateUIView(_ webView: WKWebView, context: Context) {
  }
    
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  private func initPlugins() {
    let surveyPlugin = SurveyJSPlugin()
    let saveChallenge = SaveChallengeJSPlugin()
    
    surveyPlugin.set { action, _ in
      webAction?(.survey(action))
    }
    
    saveChallenge.set { action, _ in
      webAction?(.saveChallenge(action))
    }
    
    supervisor.loadPlugin(contentsOf: [surveyPlugin, saveChallenge])
  }
}

extension BKWebView {
  final class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
    private let parent: BKWebView
    
    init(parent: BKWebView) {
      self.parent = parent
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
      guard
        message.name == BKWebViewBridge.default.bridgeName,
        let messageBody = message.body as? [String: Any],
        let action = messageBody["action"] as? String
      else { return }
      
      parent.supervisor.resolve(action, message: messageBody, with: parent.webView)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
      if let urlString = webView.url?.absoluteString {
        self.parent.viewModel.title = urlString
      }
      
      self.parent.viewModel.canGoBack = webView.canGoBack
      self.parent.viewModel.canGoForward = webView.canGoForward
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
      self.parent.viewModel.isLoading = false
    }
  }
}
