//
//  UINavigationController+.swift
//  Blink
//
//  Created by kyuchul on 7/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import UIKit

import Services

extension UINavigationController: UIGestureRecognizerDelegate {
  
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
      
      return viewControllers.count > 1  && UserDefaultsClient.liveValue.bool(.isPopGestureEnabled, false)
    }
}
