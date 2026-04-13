//
//  AlertClient+Live.swift
//  Services
//
//  Created by kyuchul on 8/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKDesignSystem

import Dependencies

extension AlertClient: DependencyKey {
  public static var liveValue: AlertClient {
    return Self(
      present: { property in
        await BkAlertManager.shared.present(property)
      },
      dismiss: {
        await BkAlertManager.shared.dismiss()
      }
    )
  }
}
