//
//  Bundle+.swift
//  Common
//
//  Created by 문정호 on 9/21/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

extension Bundle {
  public static var currentAppVersion: String {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
  }
}
