//
//  LinkTextField.swift
//  Feature
//
//  Created by 김규철 on 4/27/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

enum LinkTextFieldType {
  case content
  case memo
}

struct LinkTextField: View {
  @Binding private var content: String
  @FocusState private var isFocused: Bool
  private let type: LinkTextFieldType
  private let placeholder: String
  private let isDisabled: Bool
  
  @State private var isHighlighted: Bool = false
  
  init(
    content: Binding<String>,
    isFocused: FocusState<Bool>,
    type: LinkTextFieldType,
    placeholder: String = "",
    isDisabled: Bool
  ) {
    self._content = content
    self._isFocused = isFocused
    self.type = type
    self.placeholder = placeholder
    self.isDisabled = isDisabled
  }
  
  var body: some View {
    TextField(text: $content, axis: .vertical) {
      Text(placeholder)
        .font(.regular(size: ._14))
        .foregroundStyle(Color.bkColor(.gray800))
    }
    .tint(.bkColor(.gray800))
    .font(.regular(size: ._14))
    .frame(maxWidth: .infinity, minHeight: 20)
    .padding(.vertical, 13)
    .padding(.horizontal, 16)
    .background(
      type == .content
        ? (isDisabled ? Color.bkColor(.gray300) : .white)
        : (!isHighlighted ? Color.bkColor(.gray300) : .white)
    )
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .strokeBorder(
          isDisabled ? Color.clear : Color.bkColor(.gray400),
          lineWidth: 1
        )
    )
    .disabled(isDisabled)
    .focused($isFocused)
    .onChange(of: isFocused) { newValue in
      if type == .memo {
        isHighlighted = newValue
      }
    }
  }
}




