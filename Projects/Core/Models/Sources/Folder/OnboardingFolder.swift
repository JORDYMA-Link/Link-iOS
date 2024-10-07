//
//  OnboardingFolder.swift
//  Services
//
//  Created by kyuchul on 8/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct OnboardingFolder: Equatable {
  let ids: [Int]
  
  public init(ids: [Int]) {
    self.ids = ids
  }
}
