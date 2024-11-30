//
//  GoogleAdsClient.swift
//  Services
//
//  Created by kyuchul on 11/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import GoogleMobileAds

import Dependencies
import DependenciesMacros

@DependencyClient
public struct GoogleMobileAdsClient {
  public var start: @Sendable () async -> Void
}

extension GoogleMobileAdsClient: DependencyKey {
  public static var liveValue: GoogleMobileAdsClient = live()
  private static func live() -> GoogleMobileAdsClient {
    return GoogleMobileAdsClient(
      start: {
        await GADMobileAds.sharedInstance().start()
      }
    )
  }
}
