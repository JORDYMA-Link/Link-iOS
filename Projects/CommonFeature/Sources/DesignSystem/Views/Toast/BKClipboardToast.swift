//
//  BKClipboardToast.swift
//  CommonFeature
//
//  Created by kyuchul on 8/16/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct BKClipboardToast: View {
  public var body: some View {
    HStack(spacing: 16) {
      BKIcon(
        image: CommonFeature.Images.icoCircleCheck,
        color: .bkColor(.main500),
        size: .init(width: 24, height: 24)
      )
      
      BKText(
        text: "링크 복사가 완료되었어요",
        font: .semiBold,
        size: ._16,
        lineHeight: 24,
        color: .bkColor(.main500)
      )
      .lineLimit(1)
      .frame(maxWidth: .infinity, alignment: .leading)
      
    }
    .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
    .background(Color.bkColor(.main50))
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .shadow(color: .bkColor(.gray700).opacity(0.1), radius: 6, x: 0, y: 8)
  }
}
