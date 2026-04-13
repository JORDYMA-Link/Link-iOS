//
//  AnalyticsyLogEvent.swift
//  Analytics
//
//  Created by kyuchul on 11/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct AnalyticsLogEvent {
  public let name: AnalyticsEventName
  public let screen: AnalyticsScreenName
  public let extraParameters: [AnalyticsParameterName: Any]?
  
  public init(
    name: AnalyticsEventName,
    screen: AnalyticsScreenName,
    extraParameters: [AnalyticsParameterName : Any]? = nil
  ) {
    self.name = name
    self.screen = screen
    self.extraParameters = extraParameters
  }
  
  public var parameters: [String: Any] {
    var parameters: [String:Any] = [:]
    
    if let extraParameters {
      extraParameters.forEach { key, value in
        parameters[key.rawValue] = value
      }
    }
    
    parameters["screen"] = screen.rawValue
    return parameters
  }
}
