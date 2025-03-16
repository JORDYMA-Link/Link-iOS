//
//  BKCustomAlertPresentationModifier.swift
//  CommonFeature
//
//  Created by kyuchul on 2/26/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

private struct BKWebViewAlertPresentationModifier<InnerContent: View>: ViewModifier {
  @Binding private var isPresented: Bool
  private let innerContent: () -> InnerContent
  
  init(
    isPresented: Binding<Bool>,
    innerContent: @escaping () -> InnerContent
  ) {
    self._isPresented = isPresented
    self.innerContent = innerContent
  }
  
  func body(content: Content) -> some View {
    ZStack {
      content
        .zIndex(0)
      
      if isPresented {
        Color.bkColor(.black)
          .opacity(0.6)
          .ignoresSafeArea()
          .zIndex(1)
          .onTapGesture {
            isPresented = false
          }
        
        innerContent()
          .frame(maxWidth: 328, maxHeight: 440, alignment: .center)
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .shadow(radius: 10)
          .zIndex(2)
      }
    }
    .animation(.spring(), value: isPresented)
  }
}

public extension View {
  func bkWebViewAlert<innerContent: View>(
    isPresented: Binding<Bool>,
    @ViewBuilder innerContent: @escaping () -> innerContent
  ) -> some View {
    modifier(BKWebViewAlertPresentationModifier(isPresented: isPresented, innerContent: innerContent))
  }
}
