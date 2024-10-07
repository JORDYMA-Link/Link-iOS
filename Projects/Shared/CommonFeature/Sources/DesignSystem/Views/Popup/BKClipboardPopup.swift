//
//  BKClipboardPopup.swift
//  CommonFeature
//
//  Created by kyuchul on 8/15/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct BKClipboardPopup: View {
  private let urlString: String
  private let closeAction: () -> Void
  private let copyAction: () -> Void
  
  init(
    urlString: String,
    closeAction: @escaping () -> Void,
    copyAction: @escaping () -> Void
  ) {
    self.urlString = urlString
    self.closeAction = closeAction
    self.copyAction = copyAction
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(spacing: 8) {
        BKText(
          text: "원문 내용 복사",
          font: .semiBold,
          size: ._16,
          lineHeight: 24,
          color: .bkColor(.gray900)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Button(action: closeAction) {
          BKIcon(
            image: CommonFeature.Images.icoClose,
            color: .bkColor(.gray900),
            size: .init(width: 16, height: 16)
          )
        }
      }
      
      HStack(spacing: 6) {
        BKText(
          text: urlString,
          font: .regular,
          size: ._14,
          lineHeight: 20,
          color: .bkColor(.gray700)
        )
        .lineLimit(1)
        .frame(maxWidth: .infinity, alignment: .leading)
        
        Button(action: copyAction) {
          BKText(
            text: "복사",
            font: .semiBold,
            size: ._14,
            lineHeight: 20,
            color: .bkColor(.main300)
          )
        }
      }
      .padding(EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16))
      .background(Color.bkColor(.main50))
      .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    .padding(EdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 16))
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .shadow(color: .bkColor(.gray700).opacity(0.1), radius: 6, x: 0, y: 8)
  }
}
