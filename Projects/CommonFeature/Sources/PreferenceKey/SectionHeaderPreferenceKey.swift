//
//  SectionHeaderPreferenceKey.swift
//  CommonFeature
//
//  Created by kyuchul on 6/22/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct SectionHeaderPreferenceKey: PreferenceKey {
  public static var defaultValue: CGFloat = .zero
  
  public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
    value = max(value, nextValue())
  }
}

public struct ViewHeightGeometry: View {
  public init() {}
  
  public var body: some View {
    GeometryReader { proxy in
      Color.clear
        .preference(
          key: SectionHeaderPreferenceKey.self,
          value: proxy.frame(in: .global).maxY
        )
    }
  }
}
