//
//  GoogleAd.swift
//  Services
//
//  Created by kyuchul on 11/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import GoogleMobileAds

public struct GoogleAd: Equatable {
  public var ad: InterstitialAd

  public init(ad: InterstitialAd) {
    self.ad = ad
  }
}
