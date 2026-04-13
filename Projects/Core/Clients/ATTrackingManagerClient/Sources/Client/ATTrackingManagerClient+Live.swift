//
//  ATTrackingManagerClient+Live.swift
//  Services
//
//  Created by kyuchul on 11/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import AppTrackingTransparency

import Dependencies

extension ATTrackingManagerClient: DependencyKey {
  public static var liveValue: ATTrackingManagerClient = live()
  private static func live() -> ATTrackingManagerClient {

    return ATTrackingManagerClient(
      trackingAuthorizationStatus: {
        return ATTrackingManager.trackingAuthorizationStatus
      },
      requestTrackingAuthorization: { @MainActor in
        return await withCheckedContinuation { continuation in
          ATTrackingManager.requestTrackingAuthorization { _ in
            continuation.resume()
          }
        }
      }
    )
  }
}
