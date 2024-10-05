//
//  LinkProcessingResponse.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

struct LinkProcessingResponse: Decodable {
  let processingFeedResDtos: [LinkProcessingStatusResponse]
}

extension LinkProcessingResponse {
  func toDomain() -> LinkProcessing {
    return LinkProcessing(
      processingList: processingFeedResDtos.map { $0.toDomain() }
    )
  }
}
