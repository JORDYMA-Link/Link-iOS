//
//  ScrollViewProxy+.swift
//  Common
//
//  Created by kyuchul on 11/27/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public extension SwiftUI.ScrollViewProxy {
    func scrollTo<ID>(
        _ id: ID,
        anchor: UnitPoint? = nil,
        action: @escaping () -> Void
    ) where ID: Hashable {
        DispatchQueue.main.async {
            withAnimation(.none) {
                self.scrollTo(id, anchor: anchor)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                action()
            }
        }
    }
}
