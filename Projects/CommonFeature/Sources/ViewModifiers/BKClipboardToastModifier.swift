//
//  BKClipboardToastModifier.swift
//  CommonFeature
//
//  Created by kyuchul on 8/16/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

private struct BKClipboardToastModifier: ViewModifier {
  @Binding var isPresented: Bool
  
  func body(content: Content) -> some View {
    content
      .overlay(
        ZStack {
          if isPresented {
            VStack {
              Spacer()
              
              BKClipboardToast()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 70 + UIApplication.bottomSafeAreaInset)
            .task {
              try? await Task.sleep(for: .seconds(3))
              
              hideToast()
            }
          }
        }
          .ignoresSafeArea()
          .animation(.spring(), value: isPresented)
      )
  }
  
  private func hideToast() {
      isPresented = false
  }
}

public extension View {
  func clipboardToast(isPresented: Binding<Bool>) -> some View {
    modifier(BKClipboardToastModifier(isPresented: isPresented))
  }
}
