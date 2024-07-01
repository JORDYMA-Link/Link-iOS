//
//  SocialLogin.swift
//  CoreKit
//
//  Created by kyuchul on 6/17/24.
//  Copyright © 2024 com.jordyma.blink. All rights reserved.
//

import Foundation

public struct SocialLogin: Equatable {
  public let id: String?
  public let authorization: String
  public var identityToken: String?
  public let provider: Socialtype
  
  public init(id: String? = nil, authorization: String, identityToken: String? = nil, provider: Socialtype) {
    self.id = id
    self.authorization = authorization
    self.identityToken = identityToken
    self.provider = provider
  }
}

extension SocialLogin {
  public enum Socialtype: String {
    case kakao = "Kakao"
    case apple = "Apple"
  }
}
