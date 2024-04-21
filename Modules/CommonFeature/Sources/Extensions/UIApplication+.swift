//
//  UIWindowScene+.swift
//  CommonFeature
//
//  Created by 김규철 on 2024/04/21.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

public extension UIApplication {
    static var topSafeAreaInset: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
              let topWindow = windowScene.windows.first else {
            return 0
        }
        
        return topWindow.safeAreaInsets.top
    }
}
