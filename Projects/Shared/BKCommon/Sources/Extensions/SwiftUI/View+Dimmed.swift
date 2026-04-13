//
//  View+Dimmed.swift
//  BKCommon
//
//  Created by kyuchul on 7/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public extension View {
  func dimmedBackground(_ opacity: Double = 0.56) -> some View {
    self.overlay { Color.black.opacity(opacity) }
  }
}
