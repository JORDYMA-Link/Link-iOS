//
//  JSONDecoder+.swift
//  Services
//
//  Created by kyuchul on 7/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

extension JSONDecoder {
  static var `default`: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }
}
