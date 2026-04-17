//
//  UserNotificationClient+Live.swift
//  Services
//
//  Created by kyuchul on 9/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import UIKit
@preconcurrency import UserNotifications

import Dependencies

extension UserNotificationClient: DependencyKey {
  public static var liveValue: UserNotificationClient {
    let notificationReceiveStream = AsyncStream<NotificationPayload>.makeStream()

    return Self(
      delegate: {
        AsyncStream { continuation in
          let delegate = UserNotificationCenterDelegate(continuation: continuation)
          UNUserNotificationCenter.current().delegate = delegate
          continuation.onTermination = {  _ in _ = delegate }
        }
      },
      requestAuthorization: { @MainActor in
        try await UNUserNotificationCenter.current().requestAuthorization(options: [[.alert, .badge, .sound]])
      },
      getAuthorizationStatus: {
        let authorizationStatus = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus

        return authorizationStatus
      },
      registerForRemoteNotifications: { @MainActor in
        UIApplication.shared.registerForRemoteNotifications()
      },
      notificationReceiveStream: {
        notificationReceiveStream.stream
      },
      notificationReceiveSend: { payload in
        notificationReceiveStream.continuation.yield(payload)
      }
    )
  }
}

extension UserNotificationClient {
  final class UserNotificationCenterDelegate: NSObject, UNUserNotificationCenterDelegate, Sendable {
    let continuation: AsyncStream<DelegateEvent>.Continuation

    init(continuation: AsyncStream<DelegateEvent>.Continuation) {
      self.continuation = continuation
    }

    func userNotificationCenter(
      _ center: UNUserNotificationCenter,
      didReceive response: UNNotificationResponse,
      withCompletionHandler completionHandler: @escaping () -> Void
    ) {
      self.continuation.yield(
        .didReceiveResponse(response, completionHandler: { completionHandler() })
      )
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      self.continuation.yield(
        .willPresentNotification(notification, completionHandler: { completionHandler($0) })
      )
    }
  }
}
