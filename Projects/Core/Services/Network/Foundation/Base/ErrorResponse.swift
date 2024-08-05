//
//  ErrorResponse.swift
//  Services
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct ErrorResponse: Decodable, Error {
  private let code: String
  private let message: Int
  private let detail: String
  
  public init(
    code: String,
    message: Int,
    detail: String
  ) {
    self.code = code
    self.message = message
    self.detail = detail
  }
}
