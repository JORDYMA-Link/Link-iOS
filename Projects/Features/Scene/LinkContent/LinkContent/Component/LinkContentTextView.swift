//
//  LinkContentTextView.swift
//  Features
//
//  Created by kyuchul on 7/9/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

struct LinkContentTextView: View {
  private let content: String
  
  init(
    content: String
  ) {
    self.content = content
  }
  
  var body: some View {
    BKText(
      text: content,
      font: .regular,
      size: ._14,
      lineHeight: 20,
      color: .bkColor(.gray800)
    )
    .frame(maxWidth: .infinity, alignment: .leading)
    .multilineTextAlignment(.leading)
    .padding(EdgeInsets(top: 13, leading: 16, bottom: 13, trailing: 16))
    .background(Color.bkColor(.gray300))
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}
