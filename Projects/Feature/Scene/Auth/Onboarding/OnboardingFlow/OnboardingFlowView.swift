//
//  OnboardingFlowView.swift
//  Features
//
//  Created by kyuchul on 7/3/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import BKDesignSystem
import BKCommon

import ComposableArchitecture

public struct OnboardingFlowView: View {
  @Perception.Bindable var store: StoreOf<OnboardingFlowFeature>
  
  public init(store: StoreOf<OnboardingFlowFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      contentView
        .animation(.spring, value: store.selectedPage)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
          UIScrollView.appearance().bounces = false
        }
    }
  }
  
  private var contentView: some View {
    ZStack(alignment: .bottom) {
      onboardingTabView
      bottomControlView
    }
  }
  
  private var onboardingTabView: some View {
    TabView(selection: $store.selectedPage) {
      ForEach(Array(OnboardingType.allCases.enumerated()), id: \.element) { index, type in
        onBoardingPageView(type: type)
          .tag(index)
      }
    }
    .tabViewStyle(.page(indexDisplayMode: .never))
  }
  
  private var bottomControlView: some View {
    VStack {
      pageIndicator
      Spacer()
      actionButton
    }
  }
  
  private var pageIndicator: some View {
    OnboardingType.allCases[store.selectedPage].indicatorImage
      .padding(.vertical, 24)
  }
  
  private var actionButton: some View {
    BKRoundedButton(
      buttonType: store.selectedPage < 4 ? .black : .main,
      title: store.selectedPage < 4 ? "다음 (\(store.selectedPage + 1)/5)" : "블링크 시작하기",
      confirmAction: { store.send(store.selectedPage < 4 ? .nextButtonTapped : .startButtonTapped) }
    )
    .padding([.horizontal, .bottom], 16)
  }
  
  private func onBoardingPageView(type: OnboardingType) -> some View {
    VStack(alignment: .center, spacing: 0) {
      Spacer(minLength: 50)
      
      BKText(
        text: type.title,
        font: .semiBold,
        size: ._28,
        lineHeight: 38,
        color: .black
      )
      .lineLimit(1)
      
      BKText(
        text: type.subTitle,
        font: .regular,
        size: ._16,
        lineHeight: 24,
        color: .black
      )
      .lineLimit(2)
      .multilineTextAlignment(.center)
      
      type.image
        .resizable()
        .scaledToFit()
      
      Spacer()
    }
  }
}
