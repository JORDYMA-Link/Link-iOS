//
//  BlinkApp.swift
//  App
//
//  Created by kyuchul on 5/20/24.
//

import SwiftUI
import UserNotifications

import Services

import ComposableArchitecture
import Firebase
import FirebaseMessaging

@main
struct BlinkApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  
  init() {
    setUpKakaoSDK()
    setupNavigationBarAppearance()
  }
  
  let store = Store(initialState: RootFeature.State()) { RootFeature() }
  
  @Dependency(\.socialLogin) var socialLogin
  
  var body: some Scene {
    WindowGroup {
      RootView(store: store)
        .onOpenURL { url in
          socialLogin.handleKakaoUrl(url)
        }
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
  
  func application(_: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options _: UIScene.ConnectionOptions) -> UISceneConfiguration {
    let sceneConfig = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
    sceneConfig.delegateClass = SceneDelegate.self
    return sceneConfig
  }
}

extension BlinkApp {
  private func setUpKakaoSDK() {
    socialLogin.initKakaoSDK()
  }
  
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



