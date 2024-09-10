//
//  BKPopGestureModifier.swift
//  Features
//
//  Created by kyuchul on 9/9/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Services

import Dependencies

private struct BKPopGestureDisabledModifier: ViewModifier {
    @Dependency(\.userDefaultsClient) var userDefaults
    var isOnlyDisable: Bool = false

    func body(content: Content) -> some View {
        content
            .task {
                print("pop false")
                userDefaults.set(false, .isPopGestureEnabled)
            }
            .onDisappear {
                guard !isOnlyDisable else { return }
                Task {
                    print("pop true")
                    userDefaults.set(true, .isPopGestureEnabled)
                }
            }
    }
}

private struct BKPopGestureEnableModifier: ViewModifier {
    @Dependency(\.userDefaultsClient) var userDefaults

    func body(content: Content) -> some View {
        content
            .task {
                 userDefaults.set(true, .isPopGestureEnabled)
            }
    }
}

extension View {
    /// 스와이프로 네비게이션 가능을 해당 뷰에서만 끔
    func popGestureDisabled() -> some View {
        modifier(BKPopGestureDisabledModifier())
    }

    /// 스와이프로 네비게이션 가능을 다시 키지 않고, 끄기만 함
    ///
    /// - 네비게이션 뷰에서 이동한 뷰가 onAppear, onDisappear 관련해서 키고 끄는 타이밍 이슈가 생기기에 사용
    func popGestureOnlyDisabled() -> some View {
        modifier(BKPopGestureDisabledModifier(isOnlyDisable: true))
    }

    /// 스와이프로 네비게이션 가능을 다시 킴
    ///
    /// - 네비게이션 뷰에서 이동한 뷰가 onAppear, onDisappear 관련해서 키고 끄는 타이밍 이슈가 생기기에 사용
    func popGestureEnabled() -> some View {
        modifier(BKPopGestureEnableModifier())
    }
}
