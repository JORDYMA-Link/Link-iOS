//
//  AnalyticsManager.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 11/1/24.
//

import Foundation
import OSLog

import FirebaseAnalytics

final class AnalyticsManager {
  static let shared = AnalyticsManager()
  private let logger: Logger
  private var isEnableDebug: Bool {
#if DEBUG
    return true
#else
    return false
#endif
  }
  
  private init() { 
    self.logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "Analytics")
  }
  
  
  func logEvent(_ log: AnalyticsLogEvent) {
    Analytics.logEvent(log.name.rawValue, parameters: log.parameters)
    
    if isEnableDebug {
      eventDebugLog(log)
    }
  }
  
  func setUserId(_ userID: String?) {
    Analytics.setUserID(userID)
    
    if isEnableDebug {
      setUserIdDebugLog(userID)
    }
  }
  
  private func eventDebugLog(
          _ log: AnalyticsLogEvent,
          file: String = #file,
          line: Int = #line,
          function: String = #function
  ) {
    let fileName = (file as NSString).lastPathComponent
    let message = """
          [\(fileName):\(line)] \(function)
          Event: \(log.name.rawValue)
          Parameters: \(log.parameters.prettyString)
          """
    
    logger.debug("\(message)")
  }
  
  private func setUserIdDebugLog(
          _ userID: String?,
          file: String = #file,
          line: Int = #line,
          function: String = #function
  ) {
    let fileName = (file as NSString).lastPathComponent
    let message = """
          [\(fileName):\(line)] \(function)
          setUserId: \(userID ?? "")
          """
    
    logger.debug("\(message)")
  }
}

fileprivate extension Dictionary where Key == String {
    var prettyString: String {
        var result = ""
        for pair in self {
            result += "\n\t\(pair.key): \(pair.value),"
        }

        return result
    }
}
