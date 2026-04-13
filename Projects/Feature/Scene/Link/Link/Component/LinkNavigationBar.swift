//
//  LinkNavigationBar.swift
//  Features
//
//  Created by kyuchul on 7/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import BKDesignSystem
import BKCommon

import ComposableArchitecture

struct LinkNavigationBar: View {
  @Perception.Bindable private var store: StoreOf<LinkFeature>
  @Binding var isScrollDetected: Bool
  
  init(
    store: StoreOf<LinkFeature>,
    isScrollDetected: Binding<Bool>
  ) {
    self.store = store
    self._isScrollDetected = isScrollDetected
  }
  
  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        Spacer(minLength: 0)
        
        HStack(spacing: 0) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            BKIcon(
              image: BKDesignSystem.Images.icoChevronLeft,
              color: isScrollDetected ? .black : .white,
              size: CGSize(width: 24, height: 24)
            )
          }
          
          Spacer()
          
          Text(store.feed.title)
            .foregroundStyle(Color.black)
            .font(.semiBold(size: ._16))
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.leading, 4)
            .opacity(isScrollDetected ? 1 : 0)
          
          Spacer()
          
          Button {
            HapticFeedbackManager.shared.selection()
            store.send(.menuButtonTapped)
          } label: {
            BKIcon(
              image: BKDesignSystem.Images.icoMoreVertical,
              color: isScrollDetected ? .black : .white,
              size: CGSize(width: 24, height: 24)
            )
            .opacity(store.linkType != .summaryCompleted ? 1 : 0)
          }
        }
        .padding(.horizontal, 16)
        
        Spacer(minLength: 0)
        
        Divider()
          .foregroundStyle(Color.bkColor(.gray400))
          .frame(maxWidth: .infinity)
          .opacity(isScrollDetected ? 1 : 0)
      }
      .frame(height: 56)
      .padding(.top, UIApplication.topSafeAreaInset)
      .background(isScrollDetected ? Color.white : Color.clear)
    }
  }
}
