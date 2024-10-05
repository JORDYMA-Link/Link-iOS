//
//  BKInstructionBanner.swift
//  CommonFeature
//
//  Created by kyuchul on 8/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct BKInstructionBanner: View {
  public init() {}
  
  public var body: some View {
    HStack(spacing: 0) {
      logo
        .padding(.trailing, 8)
      
      instructionView
        .padding(.trailing, 12)
      
      BKIcon(
        image: CommonFeature.Images.icoChevronRight,
        color: .bkColor(.gray600),
        size: CGSize(width: 20, height: 20)
      )
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .frame(minWidth: 74, maxHeight: 74)
    .background(Color.bkColor(.gray300))
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
  
  @ViewBuilder
  private var logo: some View {
    Circle()
      .fill(Color.bkColor(.white))
      .frame(width: 50, height: 50)
      .overlay {
        CommonFeature.Images.graphicLogo
          .resizable()
          .scaledToFit()
          .frame(width: 32, height: 32)
      }
  }
  
  @ViewBuilder
  private var instructionView: some View {
    VStack(alignment: .leading, spacing: 2) {
      BKText(
        text: "알면 알수록 똑똑한 앱, 블링크",
        font: .regular,
        size: ._12,
        lineHeight: 18,
        color: .bkColor(.gray800)
      )
      .lineLimit(1)
      
      BKText(
        text: "100% 활용하는 방법 확인하기",
        font: .semiBold,
        size: ._14,
        lineHeight: 18,
        color: .bkColor(.main300)
      )
      .lineLimit(1)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}
