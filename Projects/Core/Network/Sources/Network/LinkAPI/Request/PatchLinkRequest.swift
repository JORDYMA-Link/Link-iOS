//
//  PatchLinkRequest.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

struct PatchLinkRequest: Encodable {
  let folderName: String
  let title: String
  let summary: String
  let keywords: [String]
  let memo: String
}
