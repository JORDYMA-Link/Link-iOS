//
//  UIApplication+.swift
//  CommonFeature
//
//  Created by kyuchul on 7/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public extension UIApplication {
    static var topSafeAreaInset: CGFloat {
      let safeAreaInset = UIApplication.shared.connectedScenes.first
          .flatMap { ($0 as? UIWindowScene)?.windows.first }?
          .flatMap { $0.safeAreaInsets }
        
      return safeAreaInset?.top ?? .zero
    }
    
    static var bottomSafeAreaInset: CGFloat {
      let safeAreaInset = UIApplication.shared.connectedScenes.first
          .flatMap { ($0 as? UIWindowScene)?.windows.first }?
          .flatMap { $0.safeAreaInsets }
        
        return safeAreaInset?.bottom ?? .zero
    }
}
