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
          
          logo
          
          Spacer()
          Spacer()
        }
        .ignoresSafeArea()
        .background(
          CommonFeature.Images.splash
            .resizable()
            .scaledToFill()
            .frame(width: proxy.size.width, height: proxy.size.height)
        )
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
}
