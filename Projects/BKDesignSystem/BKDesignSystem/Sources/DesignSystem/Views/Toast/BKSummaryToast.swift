//
//  BKSummaryToast.swift
//  CommonFeature
//
//  Created by kyuchul on 8/17/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public enum SummaryType {
  case summarizing
  case summaryComplete
}

public struct BKSummaryToast: View {
  @Binding private var summaryType: SummaryType
  private let action: () -> Void
  
  public init(
    summaryType: Binding<SummaryType>,
    action: @escaping () -> Void
  ) {
    self._summaryType = summaryType
    self.action = action
  }
  
  public var body: some View {
    HStack(spacing: 8) {
      BKText(
        text: title,
        font: .semiBold,
        size: ._16,
        lineHeight: 24,
        color: .bkColor(.white)
      )
      .lineLimit(1)
      .frame(maxWidth: .infinity, alignment: .leading)
      
      Button(action: action) {
        BKText(
          text: "보러가기",
          font: .regular,
          size: ._14,
          lineHeight: 20,
          color: .bkColor(.white)
        )
        .underline(color: .white)
      }
      
    }
    .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
    .frame(minHeight: 52, maxHeight: 52)
    .background(background)
    .clipShape(RoundedRectangle(cornerRadius: 8))
  }
}

private extension BKSummaryToast {
  private var title: String {
    switch summaryType {
    case .summarizing:
      return "링크를 요약하고 있어요"
    case .summaryComplete:
      return "링크 요약이 완료되었어요"
    }
  }
  
  private var background: some ShapeStyle {
    switch summaryType {
    case .summarizing:
      return LinearGradient(
        colors: [
          .bkColor(.gradient400),
          .bkColor(.gradient300),
          .bkColor(.gradient200),
          .bkColor(.gradient100)
        ],
        startPoint: UnitPoint(x: 0, y: 0.5),
        endPoint: UnitPoint(x: 1, y: 0.5)
      )
    case .summaryComplete:
      return LinearGradient(
        colors: [.bkColor(.main300)],
        startPoint: .top,
        endPoint: .bottom
      )
    }
  }
}
