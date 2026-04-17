//
//  UserNotificationClient.swift
//  Services
//
//  Created by kyuchul on 9/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import UIKit
@preconcurrency import UserNotifications

import Dependencies

public struct UserNotificationClient {
  public var delegate: @Sendable () -> AsyncStream<DelegateEvent>
  public var requestAuthorization: @Sendable () async throws -> Void
  public var getAuthorizationStatus: @Sendable () async -> UNAuthorizationStatus = { .notDetermined }
  public var registerForRemoteNotifications: @Sendable () async -> Void
  public var notificationReceiveStream: @Sendable () -> AsyncStream<NotificationPayload>
  public var notificationReceiveSend: @Sendable (NotificationPayload) -> Void


  public enum DelegateEvent: Sendable {
    case didReceiveResponse(UNNotificationResponse, completionHandler: @Sendable () -> Void)
    case willPresentNotification(UNNotification, completionHandler: @Sendable (UNNotificationPresentationOptions) -> Void)
  }
}

public extension DependencyValues {
  var userNotificationClient: UserNotificationClient {
    get { self[UserNotificationClient.self] }
    set { self[UserNotificationClient.self] = newValue }
  }
}
