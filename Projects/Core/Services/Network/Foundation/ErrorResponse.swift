//
//  ErrorResponse.swift
//  Services
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable, Error {
  let timestamp: String
  let status: Int
  let error: String
  let path: String
}
