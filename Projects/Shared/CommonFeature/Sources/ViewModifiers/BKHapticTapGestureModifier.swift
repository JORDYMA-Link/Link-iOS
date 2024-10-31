//
//  BKHapticTapGestureModifier.swift
//  CommonFeature
//
//  Created by kyuchul on 10/31/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Common

public enum HapticType {
  case impact(UIImpactFeedbackGenerator.FeedbackStyle)
  case notification(UINotificationFeedbackGenerator.FeedbackType)
  case selection
}

private struct BKHapticTapGestureModifier: ViewModifier {
  private let type: HapticType
  private let tapGesture: () -> Void
  
  init(
    type: HapticType,
    tapGesture: @escaping () -> Void
  ) {
    self.type = type
    self.tapGesture = tapGesture
  }
  
  func body(content: Content) -> some View {
    content
      .contentShape(Rectangle())
      .onTapGesture {
        hapticAction()
        tapGesture()
      }
  }
  
  @MainActor
  private func hapticAction() {
    switch type {
    case let .impact(style):
      HapticFeedbackManager.shared.impact(style: style)
    case let .notification(type):
      HapticFeedbackManager.shared.notification(type: type)
    case .selection:
      HapticFeedbackManager.shared.selection()
    }
  }
}

public extension View {
  func hapticTapGesture(_ type: HapticType = .impact(.light), _ tapGesture: @escaping () -> Void) -> some View {
    self.modifier(BKHapticTapGestureModifier(type: type, tapGesture: tapGesture))
  }
}
