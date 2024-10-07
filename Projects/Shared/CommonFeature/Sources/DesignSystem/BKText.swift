//
//  BKText.swift
//  CommonFeature
//
//  Created by kyuchul on 7/9/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

/// LineHeight 설정이 필요한 Text의 경우 사용
public struct BKText: View {
  private let text: String
  private let font: BKFont
  private let size: CGFloat.Size
  private let lineHeight: CGFloat
  private let color: Color
  
  public init(
    text: String,
    font: BKFont,
    size: CGFloat.Size,
    lineHeight: CGFloat,
    color: Color
  ) {
    self.text = text
    self.font = font
    self.size = size
    self.lineHeight = lineHeight
    self.color = color
  }
  
  public var body: some View {
    Text(text)
      .font(font.fontName(size: size.rawValue))
      .fontWithLineHeight(font: font.fontName(size: size.rawValue), lineHeight: lineHeight)
      .foregroundStyle(color)
  }
}
