//
//  SocialLogin.swift
//  CoreKit
//
//  Created by kyuchul on 6/17/24.
//  Copyright © 2024 com.jordyma.blink. All rights reserved.
//

import Foundation

public struct SocialLogin {
  let id: String?
  let authorization: String
  var identityToken: String?
  let provider: Socialtype
  
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
