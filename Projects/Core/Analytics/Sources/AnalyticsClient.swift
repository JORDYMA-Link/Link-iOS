//
//  AnalyticsClient.swift
//  Analytics
//
//  Created by kyuchul on 11/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
public struct AnalyticsClient {
  public var logEvent: @Sendable (_ event: AnalyticsLogEvent) -> Void
  public var setUserId: @Sendable (_ userID: String?) -> Void
}

extension AnalyticsClient: DependencyKey {
  public static var liveValue: AnalyticsClient {
    return Self(
      logEvent: { event in
        AnalyticsManager.shared.logEvent(event)
      }, 
      setUserId: { userID in
        AnalyticsManager.shared.setUserId(userID)
      }
    )
  }
}
