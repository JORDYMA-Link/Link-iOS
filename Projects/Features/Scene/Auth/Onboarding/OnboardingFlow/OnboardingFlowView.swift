//
//  OnboardingFlowView.swift
//  Features
//
//  Created by kyuchul on 7/3/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature
import Common

import ComposableArchitecture

public struct OnboardingFlowView: View {
  enum OnboardingType: CaseIterable {
    case onboarding1
    case onboarding2
    case onboarding3
    
    var image: Image {
      switch self {
      case .onboarding1:
        return CommonFeature.Images.onBoarding1
      case .onboarding2:
        return CommonFeature.Images.onBoarding2
      case .onboarding3:
        return CommonFeature.Images.onBoarding3
      }
    }
  }
  
  @Perception.Bindable var store: StoreOf<OnboardingFlowFeature>
  
  public init(store: StoreOf<OnboardingFlowFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      ZStack {
        TabView(selection: $store.selectedPage) {
          ForEach(Array(OnboardingType.allCases.enumerated()), id: \.element) { index, type in
            onBoardingPageView(type: type)
              .tag(index)
          }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        
        VStack(spacing: 0) {
          HStack {
            Spacer()
            
            SkipButton {
              store.send(.skipButtonTapped)
            }
          }
          .padding(.trailing, 16)
          .padding(.top, UIApplication.topSafeAreaInset + 41)
          
          Spacer()
          
          HStack {
            Spacer()
            
            if !store.isStart {
              NextButton {
                store.send(.nextButtonTapped)
              }
            } else {
              StartButton {
                store.send(.startButtonTapped)
              }
            }
          }
          .padding(.trailing, 16)
          .padding(.bottom, 61)
        }
      }
      .animation(.spring, value: store.selectedPage)
      .toolbar(.hidden, for: .navigationBar)
      .ignoresSafeArea(edges: .all)
      .onAppear {
        UIScrollView.appearance().bounces = false
      }
    }
  }
  
  private func onBoardingPageView(type: OnboardingType) -> some View {
    type.image
      .resizable()
      .aspectRatio(contentMode: .fill)
      .ignoresSafeArea(edges: .all)
  }
}

extension OnboardingFlowView {
  private struct SkipButton: View {
    private var action: () -> Void
    
    init(action: @escaping () -> Void) {
      self.action = action
    }
    
    var body: some View {
      Button {
        action()
      } label: {
        Text("건너뛰기")
          .foregroundStyle(Color.white)
          .font(.semiBold(size: ._16))
      }
    }
  }
  
  private struct NextButton: View {
    private var action: () -> Void
    
    init(action: @escaping () -> Void) {
      self.action = action
    }
    
    var body: some View {
      Button {
        action()
      } label: {
        BKIcon(image: CommonFeature.Images.icoChevronRight, color: .bkColor(.main300), size: CGSize(width: 24, height: 24))
          .padding()
          .background(Color.white)
          .clipShape(Circle())
      }
    }
  }
  
  private struct StartButton: View {
    private var action: () -> Void
    
    init(action: @escaping () -> Void) {
      self.action = action
    }
    
    var body: some View {
      Button {
        action()
      } label: {
        HStack(spacing: 4) {
          Text("시작하기")
            .foregroundStyle(Color.bkColor(.main300))
            .font(.semiBold(size: ._16))
          
          BKIcon(image: CommonFeature.Images.icoChevronRight, color: .bkColor(.main300), size: CGSize(width: 24, height: 24))
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 100, style: .continuous))
      }
    }
  }
}
