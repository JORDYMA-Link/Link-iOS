//
//  AddStorageBoxItem.swift
//  Features
//
//  Created by kyuchul on 8/9/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

struct AddStorageBoxItem: View {
  private let action: () -> Void
  
  init(action: @escaping () -> Void) {
    self.action = action
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 6) {
      BKIcon(
        image: CommonFeature.Images.icoPlus,
        color: .bkColor(.gray700),
        size: CGSize(width: 24, height: 24)
      )
      
      BKText(
        text: "추가하기",
        font: .regular,
        size: ._14,
        lineHeight: 20,
        color: .bkColor(.gray700)
      )
      .frame(maxWidth: .infinity, alignment: .center)
    }
    .padding(EdgeInsets(top: 16, leading: 14, bottom: 18, trailing: 14))
    .frame(minWidth: 80, maxHeight: 80)
    .background(Color.bkColor(.white))
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .shadow(color: .bkColor(.gray900).opacity(0.08), radius: 5, x: 0, y: 4)
    .onTapGesture { action() }
  }
}
