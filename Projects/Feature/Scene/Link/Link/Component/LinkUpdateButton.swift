//
//  LinkUpdateButton.swift
//  Feature
//
//  Created by 김규철 on 4/27/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

enum LinkUpdateButtonType {
  case title
  case content
}

struct LinkUpdateButton: View {
  private let isUpdatable: Bool
  private let type: LinkUpdateButtonType
  private let action: () -> Void
  
  init(
    isUpdatable: Bool,
    type: LinkUpdateButtonType,
    action: @escaping () -> Void
  ) {
    self.isUpdatable = isUpdatable
    self.type = type
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      HStack(spacing: 4) {
        BKText(
          text: isUpdatable ? "편집" : "완료",
          font: .regular,
          size: ._13,
          lineHeight: 18,
          color: .bkColor((type == .title && isUpdatable) ? .white : .gray700)
        )
        
        BKIcon(
          image: isUpdatable ? CommonFeature.Images.icoRoundEdit : CommonFeature.Images.icoCheck,
          color: .bkColor((type == .title && isUpdatable) ? .white : .gray700),
          size: .init(width: 16, height: 16))
      }
      .padding(.vertical, 4)
      .padding(.horizontal, 8)
      .background(isUpdatable ? Color.clear : Color.bkColor(.gray300))
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .strokeBorder(Color.bkColor(.gray400), lineWidth: isUpdatable ? 0 : 1)
      )
    }
  }
}
