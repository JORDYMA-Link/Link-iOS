//
//  Data+.swift
//  Common
//
//  Created by kyuchul on 11/5/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

extension Data {
  public init?(base64URLEncoded string: String) {
    let base64Encoded = string
      .replacingOccurrences(of: "_", with: "/")
      .replacingOccurrences(of: "-", with: "+")
    
    let padLength = (4 - (base64Encoded.count % 4)) % 4
    let base64EncodedWithPadding = base64Encoded + String(repeating: "=", count: padLength)
    self.init(base64Encoded: base64EncodedWithPadding)
  }
}
