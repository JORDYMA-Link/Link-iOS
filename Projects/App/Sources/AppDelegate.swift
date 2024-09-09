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
import FirebaseCore
import FirebaseMessaging

final class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  let store = StoreOf<AppDelegateFeature>.init(
      initialState: .init(),
      reducer: {
        AppDelegateFeature()
      }
    )
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    store.send(.didFinishLaunching)
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    store.send(.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken))
  }
}
