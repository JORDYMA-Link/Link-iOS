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
  public var load: @Sendable () async throws -> GoogleAd
}

extension GoogleMobileAdsClient: DependencyKey {
  public static var liveValue: GoogleMobileAdsClient = live()
  private static func live() -> GoogleMobileAdsClient {
    return GoogleMobileAdsClient(
      start: {
        await GADMobileAds.sharedInstance().start()
      },
      load: {
        let ad = try await GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest())
        
        return GoogleAd(ad: ad)
      }
    )
  }
}

public struct GoogleAd: Equatable {
  public var ad: GADInterstitialAd
  
  public init(ad: GADInterstitialAd) {
    self.ad = ad
  }
}
