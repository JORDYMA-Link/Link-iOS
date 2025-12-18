//
//  PassThroughWindow.swift
//  CommonFeature
//
//  Created by kyuchul on 8/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

final class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event),
              let rootView = rootViewController?.view
        else {
            return nil
        }
        
        if #available(iOS 26, *) {
            // NOTE: iOS 26, Xcode 26 이상 버전을 사용할 때, 결과가 nil로 나오는 문제가 있어서 name 유무를 보고 결정합니다.
            // https://stackoverflow.com/questions/79768526/passthrough-uiwindow-using-swiftui-in-ios-26
            return rootView.layer.hitTest(point)?.name == nil ? rootView : nil
        } else if #available(iOS 18, *) {
            // NOTE: iOS 18, Xcode 16 이상 버전을 사용할 때, hitTest 결과가 다르게 나옵니다.
            // view -> subView 로 이어지는 hitTest 플로우가 역으로 다시 UIHostingViewController 의 hitTest로 가는 상황이 생깁니다.
            // https://forums.developer.apple.com/forums/thread/762292
            for subview in rootView.subviews.reversed() {
                let convertedPoint = subview.convert(point, from: rootView)
                if subview.hitTest(convertedPoint, with: event) != nil {
                    return hitView
                }
            }
            return nil
        } else {
            return (hitView == self || rootView == hitView) ? nil : hitView
        }
    }
}
