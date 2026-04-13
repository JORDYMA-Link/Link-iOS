//
//  URLOpenHandlerClient.swift
//  Services
//
//  Created by kyuchul on 12/24/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKCommon

import Dependencies
import DependenciesMacros

@DependencyClient
public struct URLOpenHandlerClient {
  public var openURL: @Sendable (_ urlType: URLLiteral) async -> Void
}
