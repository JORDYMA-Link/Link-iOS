//
//  View+.swift
//  CommonFeature
//
//  Created by kyuchul on 7/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public extension View {
  /// 특정 Bool 값이 true일 때, apply 클로저를 적용하는 modifier
  @ViewBuilder
  func `if`<Content: View>(_ condition: Bool, apply: (Self) -> Content) -> some View {
    if condition {
      apply(self)
    } else {
      self
    }
  }
  
  /// 특정 Optional 값이 nil이 아닐 때, apply 클로저를 적용하는 modifier
  @ViewBuilder
  func ifLet<Content: View, Value>(_ optionalValue: Optional<Value>, apply: (Self, Value) -> Content) -> some View {
    if let value = optionalValue {
      apply(self, value)
    } else {
      self
    }
  }
}


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

public extension View {
  func modal(
    isPresented: Binding<Bool>,
    type: BKModalType
  ) -> some View {
    fullScreenCover(isPresented: isPresented) {
      BKModal(modalType: type)
        .presentationClearBackground()
    }
    .transaction { transaction in
      if isPresented.wrappedValue {
        transaction.disablesAnimations = true
        transaction.animation = .linear(duration: 0.1)
      }
    }
  }
  
  func presentationClearBackground() -> some View {
    modifier(ClearBackground())
  }
}
