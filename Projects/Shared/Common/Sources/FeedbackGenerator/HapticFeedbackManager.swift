//
//  HapticFeedbackManager.swift
//  Common
//
//  Created by kyuchul on 10/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import UIKit

@MainActor
public final class HapticFeedbackManager {
  public static let shared = HapticFeedbackManager()
  
  private var feedbackHapticGenerators: [UIImpactFeedbackGenerator.FeedbackStyle: UIImpactFeedbackGenerator] = [:]
  private let notificationGenerator: UINotificationFeedbackGenerator
  private let selectionGenerator: UISelectionFeedbackGenerator
  
  private init() {
    feedbackHapticGenerators = Dictionary(uniqueKeysWithValues: UIImpactFeedbackGenerator.FeedbackStyle.allCases.map { style in
      (style, UIImpactFeedbackGenerator(style: style))
    })
    
    notificationGenerator = UINotificationFeedbackGenerator()
    selectionGenerator = UISelectionFeedbackGenerator()
  }
  
  public func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    feedbackHapticGenerators[style]?.prepare()
    feedbackHapticGenerators[style]?.impactOccurred()
  }
  
  
  public func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
    notificationGenerator.prepare()
    notificationGenerator.notificationOccurred(type)
  }
  
  public func selection() {
    selectionGenerator.prepare()
    selectionGenerator.selectionChanged()
  }
}

extension UIImpactFeedbackGenerator.FeedbackStyle: CaseIterable {
  public static var allCases: [UIImpactFeedbackGenerator.FeedbackStyle] {
    [.light, .medium, .heavy, .soft, .rigid]
  }
}
