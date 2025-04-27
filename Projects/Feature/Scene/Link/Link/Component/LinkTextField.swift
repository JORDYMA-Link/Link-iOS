//
//  LinkTextField.swift
//  Feature
//
//  Created by 김규철 on 4/27/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

struct LinkTextField: View {
  @Binding private var content: String
  private let isDisabled: Bool
  private let maxCharacterCount = 500
  
  init(
    content: Binding<String>,
    isDisabled: Bool
  ) {
    self._content = content
    self.isDisabled = isDisabled
  }
  
  var body: some View {
    TextField("", text: $content, axis: .vertical)
      .tint(.bkColor(.gray800))
      .font(.regular(size: ._14))
      .frame(maxWidth: .infinity, minHeight: 20)
      .padding(.vertical, 13)
      .padding(.horizontal, 16)
      .linkTextFieldBackground(isDisabled: isDisabled)
      .disabled(isDisabled)
      .onChange(of: content) { newText in
        if newText.count > maxCharacterCount {
          content = String(newText.prefix(maxCharacterCount))
        }
      }
  }
}

private extension View {
  @ViewBuilder
  func linkTextFieldBackground(isDisabled: Bool) -> some View {
    if isDisabled {
      self
        .background(Color.bkColor(.gray300))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    } else {
      self
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .strokeBorder(Color.bkColor(.gray400), lineWidth: 1)
        )
    }
  }
}




