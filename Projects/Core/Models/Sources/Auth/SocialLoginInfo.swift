//
//  SocialLoginInfo.swift
//  CoreKit
//
//  Created by kyuchul on 6/17/24.
//  Copyright © 2024 com.jordyma.blink. All rights reserved.
//

import Foundation

public struct SocialLoginInfo: Equatable {
  public let idToken: String
  public let nonce: String?
  public let provider: Socialtype
  
  public init(
    idToken: String,
    nonce: String? = nil,
    provider: Socialtype
  ) {
    self.idToken = idToken
    self.nonce = nonce
    self.provider = provider
  }
}

extension SocialLoginInfo {
  public enum Socialtype: String {
    case kakao = "Kakao"
    case apple = "Apple"
  }
}
