//
//  BlinkApp.swift
//  App
//
//  Created by kyuchul on 5/20/24.
//

import SwiftUI
import UserNotifications

import Features
import CommonFeature

import ComposableArchitecture
import FirebaseCore
import FirebaseMessaging

@main
struct BlinkApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

  init() {
    setupNavigationBarAppearance()
  }
    
  var body: some Scene {
    WindowGroup {
      RootView(store: Store(initialState: RootFeature.State()) { RootFeature() })
        .alertPresentationWindow()
    }
  }
}


extension BlinkApp {
  private func setupNavigationBarAppearance() {
    let navigationBarAppearance = UINavigationBarAppearance()
    navigationBarAppearance.configureWithOpaqueBackground()
    navigationBarAppearance.titleTextAttributes = [
      NSAttributedString.Key.foregroundColor: UIColor.black
    ]
    navigationBarAppearance.backgroundColor = UIColor.white
    navigationBarAppearance.shadowColor = .clear
    UINavigationBar.appearance().standardAppearance = navigationBarAppearance
    UINavigationBar.appearance().compactAppearance = navigationBarAppearance
    UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
  }
}
