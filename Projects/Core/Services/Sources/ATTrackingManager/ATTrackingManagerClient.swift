//
//  ATTTrackingManagerClient.swift
//  Services
//
//  Created by kyuchul on 11/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import AppTrackingTransparency

import Dependencies
import DependenciesMacros

@DependencyClient
public struct ATTrackingManagerClient {
  public var trackingAuthorizationStatus: @Sendable () -> ATTrackingManager.AuthorizationStatus = { .notDetermined }
  public var requestTrackingAuthorization: @Sendable () async -> Void
}

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
