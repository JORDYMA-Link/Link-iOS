//
//  BKViewDidLoadModifier.swift
//  CommonFeature
//
//  Created by kyuchul on 9/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

private struct BKViewDidLoadModifier: ViewModifier {
  @State private var viewDidLoad = false
  private let action: (() -> Void)?
  
  init(action: (() -> Void)?) {
    self.action = action
  }
  
  func body(content: Content) -> some View {
    content
      .onAppear {
        if viewDidLoad == false {
          viewDidLoad = true
          action?()
        }
      }
  }
}

public extension View {
  func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
    self.modifier(BKViewDidLoadModifier(action: action))
  }
}
