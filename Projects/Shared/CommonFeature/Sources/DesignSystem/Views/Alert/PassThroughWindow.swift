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
        
        if #available(iOS 18, *) {
            for subview in rootView.subviews.reversed() {
                let convertedPoint = subview.convert(point, from: rootView)
                if subview.hitTest(convertedPoint, with: event) != nil {
                    return hitView
                }
            }
            return nil
        } else {
            return hitView == rootView ? nil : hitView
        }
    }
}
