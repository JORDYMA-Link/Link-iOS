//
//  URLOpenHandlerClient.swift
//  Services
//
//  Created by kyuchul on 12/24/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import UIKit

import Common

import Dependencies
import DependenciesMacros

@DependencyClient
public struct URLOpenHandlerClient {
  public var openURL: @Sendable (_ urlType: URLLiteral) async -> Void
}

extension URLOpenHandlerClient: DependencyKey {
  public static var liveValue: URLOpenHandlerClient = live()
  private static func live() -> URLOpenHandlerClient {
    
    return URLOpenHandlerClient { urlType in
      if let url = urlType.url {
        await MainActor.run {
          UIApplication.shared.open(url)
        }
      }
    }
  }
}
