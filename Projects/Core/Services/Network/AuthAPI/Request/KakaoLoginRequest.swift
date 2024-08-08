//
//  KakaoLoginRequest.swift
//  Services
//
//  Created by kyuchul on 7/1/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct KakaoLoginRequest: Encodable {
  private let idToken: String
  private let nonce: String
  
  public init(idToken: String, nonce: String) {
    self.idToken = idToken
    self.nonce = nonce
  }
}
