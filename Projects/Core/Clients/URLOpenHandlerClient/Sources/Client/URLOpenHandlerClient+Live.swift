//
//  URLOpenHandlerClient+Live.swift
//  Services
//
//  Created by kyuchul on 12/24/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import UIKit

import BKCommon

import Dependencies

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
