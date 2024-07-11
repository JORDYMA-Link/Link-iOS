//
//  ViewPreferenceKey.swift
//  CommonFeature
//
//  Created by kyuchul on 6/22/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct ViewPreferenceKey: PreferenceKey {
  public static var defaultValue: CGFloat = .zero
  
  public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}

public struct ViewMaxYGeometry: View {
  public init() {}
  
  public var body: some View {
    GeometryReader { proxy in
      Color.clear
        .preference(
          key: ViewPreferenceKey.self,
          value: proxy.frame(in: .global).maxY
        )
    }
  }
}

public struct ViewHeightGeometry: View {
  public init() {}
  
  public var body: some View {
    GeometryReader { proxy in
      Color.clear
        .preference(
          key: ViewPreferenceKey.self,
          value: proxy.size.height
        )
    }
  }
}
