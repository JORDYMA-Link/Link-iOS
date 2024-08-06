//
//  AppDelegate.swift
//  Blink
//
//  Created by kyuchul on 8/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Features

import ComposableArchitecture

final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  let store = Store(
      initialState: AppDelegateFeature.State(),
      reducer: { AppDelegateFeature() }
    )
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    store.send(.didFinishLaunching)
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
  }
}
