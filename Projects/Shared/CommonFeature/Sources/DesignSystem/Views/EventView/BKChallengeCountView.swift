//
//  BKChallengeCountView.swift
//  CommonFeature
//
//  Created by kyuchul on 8/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

struct BKChallengeCountView: View {
  private let count: Int
  
  private let challengeImages = [
    CommonFeature.Images.challenge1,
    CommonFeature.Images.challenge2,
    CommonFeature.Images.challenge3,
    CommonFeature.Images.challenge4,
    CommonFeature.Images.challenge5
  ]
  
  init(count: Int) {
    self.count = count
  }
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(0..<5, id: \.self) { index in
        challengeImages[index]
          .opacity(count == index + 1 ? 1.0 : 0.4)
      }
    }
  }
} 