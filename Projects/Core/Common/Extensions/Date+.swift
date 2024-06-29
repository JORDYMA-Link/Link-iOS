//
//  Date+.swift
//  Common
//
//  Created by 문정호 on 6/29/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

extension Date {
  public var toStringYearMonth: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "YYYY. MM."
    return formatter.string(from: self)
  }
}
