//
//  StorageBoxItem.swift
//  Features
//
//  Created by kyuchul on 8/9/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

struct StorageBoxItem: View {
  private let count: Int
  private let name: String
  private let menuAction: () -> Void
  private let itemAction: () -> Void
  
  init(
    count: Int,
    name: String,
    menuAction: @escaping () -> Void,
    itemAction: @escaping () -> Void
  ) {
    self.count = count
    self.name = name
    self.menuAction = menuAction
    self.itemAction = itemAction
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      HStack {
        BKText(
          text: "\(count)개",
          font: .regular,
          size: ._12,
          lineHeight: 18,
          color: .bkColor(.gray800)
        )
        .lineLimit(1)
        
        Spacer(minLength: 4)
        
        Button(action: menuAction) {
          BKIcon(
            image: CommonFeature.Images.icoMoreVertical,
            color: .bkColor(.gray600),
            size: CGSize(width: 20, height: 20)
          )
        }
      }
      
      BKText(
        text: name,
        font: .semiBold,
        size: ._14,
        lineHeight: 20,
        color: .bkColor(.gray900)
      )
      .lineLimit(1)
      .frame(maxWidth: .infinity, alignment: .leading)
    }
    .padding(EdgeInsets(top: 16, leading: 14, bottom: 18, trailing: 14))
    .frame(minWidth: 80, maxHeight: 80)
    .background(Color.bkColor(.white))
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .shadow(color: .bkColor(.gray900).opacity(0.08), radius: 5, x: 0, y: 4)
    .onTapGesture { itemAction() }
  }
}
