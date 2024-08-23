//
//  LinkTitleButton.swift
//  Features
//
//  Created by kyuchul on 7/9/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

struct LinkTitleButton: View {
  private let title: String
  private let buttonTitle: String
  private let action: () -> Void
  
  init(
    title: String,
    buttonTitle: String,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.buttonTitle = buttonTitle
    self.action = action
  }
  
  var body: some View {
    HStack(spacing: 6) {
      BKText(
        text: title,
        font: .semiBold,
        size: ._18,
        lineHeight: 26,
        color: .bkColor(.gray900)
      )
      
      Text(buttonTitle)
        .foregroundStyle(Color.bkColor(.gray600))
        .font(.regular(size: ._12))
        .onTapGesture { action() }
    }
  }
}
