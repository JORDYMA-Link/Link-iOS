//
//  Date+.swift
//  Common
//
//  Created by 문정호 on 6/29/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

extension Date {
  public var toStringOnlyYearAndMonth: String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "ko_KR")
    formatter.dateFormat = "YYYY. MM."
    return formatter.string(from: self)
  }
  
  public func toString(formatter: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = formatter
    dateFormatter.timeZone = TimeZone(identifier: "ko_KR")
    return dateFormatter.string(from: self)
  }
  
  ///현재 Date로부터 Component의 value만큼 더해진 Date를 계산하여 반환한다.
  public func calculatingByAddingDate(byAdding: Calendar.Component, value: Int) throws -> Date {
    let calendar = Calendar.current
    
    guard let exactDate = calendar.date(byAdding: byAdding, value: value, to: self) else { throw LocalError.dateError }
    
    return exactDate
  }
  
  public func getDateComponents(dateComponents: Set<Calendar.Component> = [.year, .month, .day]) -> DateComponents {
    let calendar = Calendar.current
    
    let components = calendar.dateComponents(dateComponents, from: self)
    
    return components
  }
  
  ///우리 서비스는 2024년을 기준으로 그 이상만을 제공합니다. 그렇기에 2024년을 기준점으로 잡아 해당 날짜가 작다면 True를 반환합니다.
  public var lessThan2024: Bool {
    let dateComponents = getDateComponents()
    return dateComponents.year ?? 2024 < 2024
  }
}
