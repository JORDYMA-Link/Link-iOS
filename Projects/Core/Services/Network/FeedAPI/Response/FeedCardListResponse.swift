//
//  FeedCardListResponse.swift
//  Services
//
//  Created by kyuchul on 8/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

struct FeedCardListResponse: Decodable {
  let feedList: [FeedCardResponse]
}
