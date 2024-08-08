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
      ZStack {
        Color.bkColor(.white).ignoresSafeArea()
        
        VStack(spacing: 0) {
          Spacer()
          
          makeLogo()
          makeTitle()
          
          Spacer()
        }
      }
    }
  }
  
  @ViewBuilder
  private func makeLogo() -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 25, style: .continuous)
        .fill(Color.bkColor(.main300))
        .frame(width: 135, height: 135)
      
      BKIcon(image: CommonFeature.Images.logoWhite, color: .white, size: CGSize(width: 64, height: 70))
    }
  }
  
  @ViewBuilder
  private func makeTitle() -> some View {
    Text("눈 깜짝할 새 저장되는\nAI 링크 아카이빙, 블링크")
      .font(.semiBold(size: ._20))
      .foregroundStyle(Color.bkColor(.gray900))
      .multilineTextAlignment(.center)
      .padding(.top, 16)
      .frame(alignment: .center)
  }
}
