//
//  StorageBoxFeedListHeader.swift
//  Features
//
//  Created by kyuchul on 9/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

struct StorageBoxFeedListHeader: View {
  @Perception.Bindable private var store: StoreOf<StorageBoxFeedListFeature>
  
  init(store: StoreOf<StorageBoxFeedListFeature>) {
    self.store = store
  }
  
  var body: some View {
    WithPerceptionTracking {
      HStack(spacing: 8) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          BKIcon(
            image: CommonFeature.Images.icoChevronLeft,
            color: .bkColor(.gray900),
            size: CGSize(width: 24, height: 24)
          )
        }
        
        BKText(
          text: store.folderInput.name,
          font: .semiBold,
          size: ._16,
          lineHeight: 24,
          color: .bkColor(.gray900)
        )
        .lineLimit(1)
        
        Spacer()
      }
    }
  }
}
