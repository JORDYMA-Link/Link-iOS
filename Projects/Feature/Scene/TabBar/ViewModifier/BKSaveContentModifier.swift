//
//  BKSaveContentModifier.swift
//  Features
//
//  Created by kyuchul on 7/29/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

struct BKSaveContentModifier: ViewModifier {
  @Binding var isPresented: Bool
  private let action: () -> Void
  
  init(
    isPresented: Binding<Bool>,
    action: @escaping () -> Void
  ) {
    self._isPresented = isPresented
    self.action = action
  }
  
  func body(content: Content) -> some View {
    if isPresented {
      Color.black.opacity(0.6).ignoresSafeArea()
        .hapticTapGesture {
          withAnimation {
            isPresented = false
          }
        }
    }
    
    VStack(spacing: 0) {
      if isPresented {
        BKSaveContentMenu(action: action)
          .padding(.bottom, 62)
      }
      
      content
    }
  }
}

extension View {
  func presentSaveContent(_ isPresented: Binding<Bool>, action: @escaping () -> Void) -> some View {
    self.modifier(BKSaveContentModifier(isPresented: isPresented, action: action))
  }
}
