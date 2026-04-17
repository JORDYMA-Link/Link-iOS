//
//  AlertClient.swift
//  Services
//
//  Created by kyuchul on 8/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKDesignSystem

import Dependencies

public struct AlertClient {
  public var present: @Sendable (_ property: BKAlertProperty) async -> Void
  public var dismiss: @Sendable () async -> Void
}

public extension DependencyValues {
  var alertClient: AlertClient {
    get { self[AlertClient.self] }
    set { self[AlertClient.self] = newValue }
  }
}
