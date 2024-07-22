//
//  BKSearchTextField.swift
//  CommonFeature
//
//  Created by kyuchul on 6/9/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

public struct BKSearchTextField: View {
  @Binding var text: String
  private var textFieldType: BKTextFieldType
  private var height: CGFloat
  private enum Constants: CGFloat {
    case vertical = 26
  }
  
  public init(
    text: Binding<String>,
    textFieldType: BKTextFieldType,
    height: CGFloat
  ) {
    _text = text
    self.textFieldType = textFieldType
    self.height = height
  }
    
  public var body: some View {
    HStack(spacing: 6) {
      makeTextField()
        .frame(height: height - Constants.vertical.rawValue)
      
      Spacer()
      
      if text.isEmpty {
        BKIcon(image: CommonFeature.Images.icoSearch, color: .bkColor(.gray600), size: CGSize(width: 18, height: 18))
      } else {
        makeClearButton()
      }
    }
    .padding(.vertical, 13)
    .padding(.horizontal, 16)
    .background(Color.bkColor(.gray300))
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
  
  @ViewBuilder
  private func makeTextField() -> some View {
    TextField(text: $text) {
      Text(textFieldType.placeholder)
        .font(.regular(size: ._14))
        .foregroundStyle(Color.bkColor(.gray800))
    }
    .tint(.bkColor(.gray900))
    .font(.regular(size: ._14))
    .submitLabel(.done)
  }
  
  @ViewBuilder
  private func makeClearButton() -> some View {
    Button {
      text = ""
    } label: {
      BKIcon(
        image: CommonFeature.Images.icoCircleCloseFill,
        color: .bkColor(.gray600),
        size: CGSize(width: 18, height: 18))
    }
    .opacity(!text.isEmpty ? 1 : 0)
  }
}
