//
//  SplashView.swift
//  Blink
//
//  Created by kyuchul on 6/7/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

public struct SplashView: View {
  @Perception.Bindable var store: StoreOf<SplashFeature>
  
  public init(store: StoreOf<SplashFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      GeometryReader { proxy in
        VStack {
          Spacer()
          Spacer()
          
          logo
          
          Spacer()
          
          bottomImage(width: proxy.size.width)
        }
        .ignoresSafeArea(edges: .bottom)
      }
    }
  }
  
  private var logo: some View {
    VStack(spacing: 16) {
      BKText(
        text: "정보 욕심러의 필수 앱",
        font: .semiBold,
        size: ._24,
        lineHeight: 34,
        color: .bkColor(.main900)
      )
      .frame(maxWidth: .infinity, alignment: .center)
      
      CommonFeature.Images.icoSplashLogo
    }
  }
  
  private func bottomImage(width: CGFloat) -> some View {
    CommonFeature.Images.splash
      .resizable()
      .scaledToFit()
      .frame(width: width)
      .filled {
        LinearGradient(
          stops: [
            Gradient.Stop(color: .white, location: 0.00),
            Gradient.Stop(color: .white.opacity(0), location: 1.00),
          ],
          startPoint: UnitPoint(x: 0.48, y: 0.03),
          endPoint: UnitPoint(x: 0.48, y: 0.94)
        )
      }
  }
}
