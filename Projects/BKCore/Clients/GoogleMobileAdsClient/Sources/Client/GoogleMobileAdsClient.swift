//
//  GoogleMobileAdsClient.swift
//  Services
//
//  Created by kyuchul on 11/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
public struct GoogleMobileAdsClient {
  public var start: @Sendable () async -> Void
  public var load: @Sendable () async throws -> GoogleAd
}
