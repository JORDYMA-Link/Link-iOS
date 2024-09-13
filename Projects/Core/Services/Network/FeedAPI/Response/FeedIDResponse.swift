//
//  FeedIDResponse.swift
//  Services
//
//  Created by kyuchul on 9/9/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

/// 링크 요약 response
struct FeedIDResponse: Decodable {
  let feedId: Int
}

/// 링크 저장(수정) response
struct SummaryIDResponse: Decodable {
  let id: Int
}
