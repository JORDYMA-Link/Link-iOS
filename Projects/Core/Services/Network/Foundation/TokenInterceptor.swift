//
//  TokenInterceptor.swift
//  Services
//
//  Created by kyuchul on 6/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Moya

protocol Interceptorable {
  
}

public final class TokenInterceptor: RequestInterceptor, Interceptorable {
  
  static let shard = TokenInterceptor()
  private init() { }
  
}
