//
//  LinkProcessingStatusResponse.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

struct LinkProcessingStatusResponse: Decodable {
  let feedId: Int
  let title: String
  let status: String
}

extension LinkProcessingStatusResponse {
  func toDomain() -> LinkProcessingStatus {
    return LinkProcessingStatus(
      feedId: feedId,
      title: title,
      status: status
    )
  }
}
