//
//  PasteboardClient.swift
//  Services
//
//  Created by 김규철 on 4/11/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Dependencies
import DependenciesMacros

@DependencyClient
public struct PasteboardClient {
  public var hasString: @Sendable () -> AsyncStream<Void> = { .finished }
  public var hasChange: @Sendable () -> AsyncStream<Void> = { .finished }
  public var pasteboardURL: @Sendable () async -> String?
}
