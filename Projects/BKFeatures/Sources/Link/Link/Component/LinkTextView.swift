//
//  LinkTextView.swift
//  Features
//
//  Created by kyuchul on 7/9/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import BKDesignSystem
import BKCommon

struct LinkTextView: View {
  private let content: String
  @State private var contentHeight: CGFloat = 0
  @State private var isExpandable: Bool = false
  
  init(
    content: String
  ) {
    self.content = content
  }
  
  var body: some View {
    VStack(spacing: 10) {
      Text(content.parseBoldString(font: .semiBold(size: ._14), color: .bkColor(.gray900)))
        .font(.regular(size: ._14))
        .fontWithLineHeight(font: BKFont.regular.fontName(size: 14), lineHeight: 20)
        .foregroundStyle(Color.bkColor(.gray800))
        .background(ViewHeightGeometry())
        .onPreferenceChange(ViewPreferenceKey.self) { height in
          DispatchQueue.main.async {
            if !content.isEmpty && height > 0 {
              contentHeight = height
            }
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .lineLimit(isExpandable && contentHeight > 60 ? nil : 3)
        .multilineTextAlignment(.leading)
      
      if !isExpandable && contentHeight > 60 {
        Divider()
          .foregroundStyle(Color.bkColor(.gray400))
          .frame(maxWidth: .infinity)
        
        LinkTextViewExpandButton(action: { isExpandable = true })
      }
    }
    .padding(EdgeInsets(top: 13, leading: 16, bottom: 13, trailing: 16))
    .background(Color.bkColor(.gray300))
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .animation(.default, value: isExpandable)
  }
}

private struct LinkTextViewExpandButton: View {
  private let action: () -> Void
  
  init(action: @escaping () -> Void) {
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      HStack {
        BKText(
          text: "펼치기",
          font: .regular,
          size: ._14,
          lineHeight: 20,
          color: .bkColor(.gray800)
        )
        
        BKDesignSystem.Images.icoChevronDown
      }
      .frame(maxWidth: .infinity, minHeight: 20, maxHeight: 20)
    }
  }
}
