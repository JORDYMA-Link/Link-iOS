//
//  PasteboardClient.swift
//  Services
//
//  Created by 김규철 on 4/11/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import UIKit
import Combine

import Dependencies
import DependenciesMacros

@DependencyClient
public struct PasteboardClient {
  public var hasString: @Sendable () -> AsyncStream<Void> = { .finished }
  public var hasChange: @Sendable () -> AsyncStream<Void> = { .finished }
  public var pasteboardURL: @Sendable () async -> String?
}

extension PasteboardClient: DependencyKey {
  public static var liveValue: PasteboardClient = live()
  private static func live() -> PasteboardClient {
    return PasteboardClient(
      hasString: { UIPasteboard.general.hasString },
      hasChange: { UIPasteboard.general.hasChange },
      pasteboardURL: {
        guard let urlString = UIPasteboard.general.string,
              urlString.isHTTPURL else {
          return nil
        }
        
        //          let pattern = try await UIPasteboard.general.detectedPatterns(for: [\.probableWebURL])
        //
        //          guard pattern.contains(\.probableWebURL) else {
        //            return nil
        //          }
        
        return UIPasteboard.general.string
      }
    )
  }
}


extension UIPasteboard {
  var hasChange: AsyncStream<Void> {
    Publishers.Merge(
      NotificationCenter.default
        .publisher(for: UIPasteboard.changedNotification)
        .compactMap { [weak self] _ in self?.changeCount },
      NotificationCenter.default
        .publisher(for: UIApplication.didBecomeActiveNotification)
        .compactMap { [weak self] _ in self?.changeCount }
    )
    .removeDuplicates()
    .map { _ in }
    .values
    .eraseToStream()
  }
  
  var hasString: AsyncStream<Void> {
    return Just(hasStrings)
      .merge(
        with: NotificationCenter.default
          .publisher(for: UIPasteboard.changedNotification)
          .compactMap { [weak self] _ in self?.hasStrings }
      )
      .merge(
        with: NotificationCenter.default
          .publisher(for: UIApplication.didBecomeActiveNotification)
          .compactMap { [weak self] _ in self?.hasStrings }
      )
      .eraseToAnyPublisher()
      .map { _ in }
      .values
      .eraseToStream()
  }
}
