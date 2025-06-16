//
//  TokenRequest.swift
//  Services
//
//  Created by 김규철 on 6/6/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import Foundation

struct TokenRequest: Encodable {
  private let idToken: String
  
  init(idToken: String) {
    self.idToken = idToken
  }
}
