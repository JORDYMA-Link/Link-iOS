//
//  LinkTextView.swift
//  Features
//
//  Created by kyuchul on 7/9/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

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
      Text(content.parseBoldString())
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
        
        CommonFeature.Images.icoChevronDown
      }
      .frame(maxWidth: .infinity, minHeight: 20, maxHeight: 20)
    }
  }
}

private extension String {
  func parseBoldString() -> AttributedString {
    let pattern = "\\*\\*(.*?)\\*\\*"
    let regex = try! NSRegularExpression(pattern: pattern)
    
    let cleanText = self.replacingOccurrences(of: "**", with: "")
    var attributedString = AttributedString(cleanText)
    
    let matches = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
    
    for match in matches {
      if let range = Range(match.range(at: 1), in: self) {
        let boldText = String(self[range])
        
        if let startRange = cleanText.range(of: boldText) {
          let startIndex = cleanText.distance(from: cleanText.startIndex, to: startRange.lowerBound)
          let length = boldText.count
          
          if let attributedRange = Range(NSRange(location: startIndex, length: length), in: attributedString) {
            attributedString[attributedRange].font = UIFont.semiBold(size: ._14)
            attributedString[attributedRange].foregroundColor = BKColor.gray900.color
          }
        }
      }
    }
    
    return attributedString
  }
}
