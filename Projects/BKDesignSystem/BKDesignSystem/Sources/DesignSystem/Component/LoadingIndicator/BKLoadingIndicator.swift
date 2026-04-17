//
//  BKLoadingIndicator.swift
//  CommonFeature
//
//  Created by kyuchul on 11/26/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Lottie

public struct BKLoadingIndicator: View {
  public init() {}
  
  public var body: some View {
    LottieView(
      animation: .named(
        "loadingIndicator",
        bundle: BKDesignSystemResources.bundle
      )
    )
    .playing(loopMode: .loop)
    .backgroundBehavior(.pauseAndRestore)
  }
}
