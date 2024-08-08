//
//  BKKeyboardHeightModifier.swift
//  CommonFeature
//
//  Created by kyuchul on 8/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI
import Combine

struct BKKeyboardHeightModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { newHeight in
                withAnimation(.easeOut(duration: 0.3)) {
                    self.keyboardHeight = newHeight
                }
            }
    }
}

public extension View {
    func setKeyboardHeight() -> some View {
        ModifiedContent(content: self, modifier: BKKeyboardHeightModifier())
    }
}
