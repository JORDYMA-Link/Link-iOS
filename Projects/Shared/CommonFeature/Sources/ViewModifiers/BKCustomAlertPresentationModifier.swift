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
          .frame(minWidth: 280, minHeight: 300)
          .padding(30)
          .background(.white)
          .clipShape(RoundedRectangle(cornerRadius: 20))
          .shadow(radius: 20)
          .padding()
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
