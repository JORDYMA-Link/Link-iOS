//
//  KakaoChannelClient.swift
//  Services
//
//  Created by kyuchul on 12/24/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
public struct KakaoChannelClient {
  public var chatChannel: @Sendable () async throws -> Void
}
