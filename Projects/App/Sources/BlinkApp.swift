//
//  BlinkApp.swift
//  App
//
//  Created by kyuchul on 5/20/24.
//

import SwiftUI
import UserNotifications

import Services
import Features

import ComposableArchitecture
import Firebase
import FirebaseMessaging

@main
struct BlinkApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  init() {
    socialLogin.initKakaoSDK()
    setupNavigationBarAppearance()
  }
  
  @Dependency(\.socialLogin) var socialLogin
  
  var body: some Scene {
    WindowGroup {
      RootView(store: Store(initialState: RootFeature.State()) { RootFeature() })
    }
  }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  }
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    return true
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
