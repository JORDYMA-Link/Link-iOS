//
//  OnboardingFolderResponse.swift
//  Services
//
//  Created by kyuchul on 8/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

struct OnboardingFolderResponse: Decodable {
  let ids: [Int]
}

extension OnboardingFolderResponse {
  public func toDomain() -> OnboardingFolder {
    return OnboardingFolder(ids: ids)
  }
}
