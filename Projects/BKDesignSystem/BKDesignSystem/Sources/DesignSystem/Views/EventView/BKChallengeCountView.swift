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
    BKDesignSystem.Images.challenge1,
    BKDesignSystem.Images.challenge2,
    BKDesignSystem.Images.challenge3,
    BKDesignSystem.Images.challenge4,
    BKDesignSystem.Images.challenge5
  ]
  
  init(count: Int) {
    self.count = count
  }
  
  var body: some View {
    HStack(spacing: 8) {
      ForEach(0..<5, id: \.self) { index in
        challengeImages[index]
          .opacity(count >= 5 || index < count ? 1.0 : 0.4)
      }
    }
    .background(.white)
  }
}
