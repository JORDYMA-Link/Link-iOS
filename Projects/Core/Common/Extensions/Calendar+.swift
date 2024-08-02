//
//  Calendar+.swift
//  Common
//
//  Created by 문정호 on 7/22/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

extension Calendar {
  //원하는 날짜 Int값을 넘기면 Date 계산을 시도하는 함수입니다.
  public func getDateFromComponents(year: Int, month: Int = 1, day: Int = 1) -> Date? {
    var calendar = Calendar.current
    
    let components = DateComponents(year: year, month: month, day: day)
    
    return (calendar.date(from: components) ?? Date()) + 86400
  }
}
