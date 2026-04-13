//
//  OnboardingRequest.swift
//  Network
//
//  Created by Claude on 2025/08/30.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import Foundation

struct OnboardingRequest: Encodable {
  let jobField: String
  let birthYear: String
  let gender: String
}