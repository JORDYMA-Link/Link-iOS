//
//  GoogleMobileAdsClient+Live.swift
//  Services
//
//  Created by kyuchul on 11/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import GoogleMobileAds

import BKCommon

import Dependencies

extension GoogleMobileAdsClient: DependencyKey {
  public static var liveValue: GoogleMobileAdsClient = live()
  private static func live() -> GoogleMobileAdsClient {
    return GoogleMobileAdsClient(
      start: {
        await MobileAds.shared.start()
      },
      load: {
        var adUnitID: String {
      #if DEBUG
          return "ca-app-pub-3940256099942544/4411468910"
      #else
          return Bundle.infoValue(for: "GOOGLE_AD_UNITID")
      #endif
        }

        do {
          let ad = try await InterstitialAd.load(with: adUnitID, request: Request())

          return GoogleAd(ad: ad)
        } catch {
          throw error
        }
      }
    )
  }
}
