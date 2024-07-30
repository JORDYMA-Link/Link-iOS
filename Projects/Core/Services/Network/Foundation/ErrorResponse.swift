//
//  ErrorResponse.swift
//  Services
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct ErrorResponse: Decodable, Error {
  let timestamp: String
  let status: Int
  let error: String
  let path: String
  
  public init(timestamp: String, status: Int, error: String, path: String) {
    self.timestamp = timestamp
    self.status = status
    self.error = error
    self.path = path
  }
}
