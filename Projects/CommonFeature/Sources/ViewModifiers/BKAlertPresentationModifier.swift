//
//  BKAlertPresentationModifier.swift
//  CommonFeature
//
//  Created by kyuchul on 8/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

private struct BKAlertPresentationModifier: ViewModifier {
  @State private var alertWindow: UIWindow?
  
  public func body(content: Content) -> some View {
    content
      .onAppear {
        guard alertWindow == nil else { return }
        guard let windowScene = UIApplication.shared.firstWindowScene else { return assertionFailure("Could not get a UIWindowScene") }
        
        let window = PassThroughWindow(windowScene: windowScene)
        let rootViewController = UIHostingController(rootView: BKAlertRootView())
        rootViewController.view.backgroundColor = .clear
        window.rootViewController = rootViewController
        window.backgroundColor = .clear
        window.isHidden = false
        window.windowLevel = .alert
        window.isUserInteractionEnabled = true
        self.alertWindow = window
      }
  }
}

public extension View {
  func BKAlertPresentationWindow() -> some View {
    modifier(BKAlertPresentationModifier())
  }
}
