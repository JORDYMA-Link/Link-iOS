//
//  AppDelegate.swift
//  Blink
//
//  Created by kyuchul on 8/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Feature
import UserNotificationClient

import ComposableArchitecture

final class AppDelegate: UIResponder, UIApplicationDelegate {
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
    UNUserNotificationCenter.current().delegate = self
    store.send(.didFinishLaunching)
    return true
  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    store.send(.didRegisterForRemoteNotificationsWithDeviceToken(deviceToken: deviceToken))
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if url.scheme == "blink" {
      return true
    }
    
    return false
  }
}

extension AppDelegate: @preconcurrency UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    let notificationId = userInfo["id"] as? String ?? UUID().uuidString
    let payload = NotificationPayload(id: notificationId, userInfo: userInfo)
    
    store.send(.didReceiveRemoteNotification(payload))
    completionHandler()
  }
}
