//
//  NotificationPayload.swift
//  UserNotificationClient
//
//  Created by 김규철 on 4/13/26.
//  Copyright © 2026 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct NotificationPayload: Equatable, @unchecked Sendable {
  public let id: String
  public let userInfo: [AnyHashable: Any]
  
  public init(
    id: String,
    userInfo: [AnyHashable : Any]
  ) {
    self.id = id
    self.userInfo = userInfo
  }
  
  public static func == (lhs: NotificationPayload, rhs: NotificationPayload) -> Bool {
    lhs.id == rhs.id
  }
}
