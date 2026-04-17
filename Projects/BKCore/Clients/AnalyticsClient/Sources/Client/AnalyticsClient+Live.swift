//
//  AnalyticsClient+Live.swift
//  Analytics
//
//  Created by 김규철 on 4/13/26.
//  Copyright © 2026 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Dependencies

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
