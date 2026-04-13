//
//  View+Keyboard.swift
//  BKCommon
//
//  Created by kyuchul on 7/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }

  func tapToHideKeyboard() -> some View {
    self
      .contentShape(Rectangle())
      .onTapGesture {
        hideKeyboard()
      }
  }
}
