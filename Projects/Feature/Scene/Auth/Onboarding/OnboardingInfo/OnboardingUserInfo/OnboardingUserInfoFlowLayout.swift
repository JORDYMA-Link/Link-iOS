//
//  OnboardingUserInfoFlowLayout.swift
//  Feature
//
//  Created by 김규철 on 9/1/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

struct OnboardingUserInfoFlowLayout: Layout {
  private var verticalSpacing: CGFloat
  private var horizontalSpacing: CGFloat
  
  init(
    verticalSpacing: CGFloat,
    horizontalSpacing: CGFloat) {
      self.verticalSpacing = verticalSpacing
      self.horizontalSpacing = horizontalSpacing
    }
  
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) -> CGSize {
    return CGSize(width: proposal.width ?? 0, height: cache.height)
  }
  
  func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Cache) {
    var sumX: CGFloat = bounds.minX
    var sumY: CGFloat = bounds.minY
    
    for index in subviews.indices {
      let view = subviews[index]
      let viewSize = view.sizeThatFits(.unspecified)
      guard let proposalWidth = proposal.width else { continue }
      
      if (sumX + viewSize.width > proposalWidth) {
        sumX = bounds.minX
        sumY += viewSize.height
        sumY += verticalSpacing
      }
      
      let point = CGPoint(x: sumX, y: sumY)
      view.place(at: point, anchor: .topLeading, proposal: proposal)
      sumX += viewSize.width
      sumX += horizontalSpacing
    }
    
    if let firstViewSize = subviews.first?.sizeThatFits(.unspecified) {
      cache.height = sumY + firstViewSize.height - bounds.minY
    }
  }
  
  struct Cache {
    var height: CGFloat
  }
  
  func makeCache(subviews: Subviews) -> Cache {
    return Cache(height: 0)
  }
  
  func updateCache(_ cache: inout Cache, subviews: Subviews) {}
}
