//
//  PresentationClearBackground.swift
//  CommonFeature
//
//  Created by kyuchul on 7/21/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

internal struct ClearBackground: ViewModifier {
  func body(content: Content) -> some View {
    if #available(iOS 16.4, *) {
      content
        .presentationBackground(.clear)
    } else {
      content
        .background(ClearBackgroundView())
    }
  }
}

fileprivate struct ClearBackgroundView: UIViewRepresentable {
  func makeUIView(context: Context) -> UIView {
    return InnerView()
  }
  
  func updateUIView(_ uiView: UIView, context: Context) {
  }
  
  private class InnerView: UIView {
    override func didMoveToWindow() {
      super.didMoveToWindow()
      
      superview?.superview?.backgroundColor = .clear
    }
    
  }
}
