//
//  EditLinkContentView.swift
//  Features
//
//  Created by kyuchul on 7/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture

struct EditLinkContentView: View {
  @Bindable var store: StoreOf<EditLinkContentFeature>
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      makeBKNavigationView(
        leadingType: .pop("내용수정"),
        trailingType: .pop(action: { store.send(.closeButtonTapped) })
      )
      
      BKText(
        text: "요약 내용",
        font: .semiBold,
        size: ._18,
        lineHeight: 26,
        color: .bkColor(.gray900)
      )
      .padding(.top, 8)
      
      Spacer()
      Spacer()
    }
    .padding(.horizontal, 16)
  }
}
