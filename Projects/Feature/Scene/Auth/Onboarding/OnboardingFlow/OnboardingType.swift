//
//  OnboardingType.swift
//  Feature
//
//  Created by 김규철 on 9/1/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

extension OnboardingFlowView {
  enum OnboardingType: CaseIterable {
    case onboarding1
    case onboarding2
    case onboarding3
    case onboarding4
    case onboarding5
    
    var title: String {
      switch self {
      case .onboarding1:
        return "어떤 정보든 내 손 안에"
      case .onboarding2:
        return "한눈에 쏙, 콘텐츠 정리"
      case .onboarding3:
        return "AI 요약 및 자동 태그"
      case .onboarding4:
        return "5초 안에 간편 스크랩"
      case .onboarding5:
        return "언제 어디서든 손쉽게"
      }
    }
    
    var subTitle: String {
      switch self {
      case .onboarding1:
        return
               """
               어떤 블로그 아티클이든
               보고 있는 콘텐츠를 저장할 수 있어요
               """
      case .onboarding2:
        return
              """
              키워드 기반 자동태깅으로
              저장한 콘텐츠를 손쉽게 관리할 수 있어요
              """
      case .onboarding3:
        return
               """
               링크를 붙여넣으면 단숨에
               콘텐츠 요약과 정리를 한 번에 도와줘요
               """
      case .onboarding4:
        return
               """
               브라우저와 앱 내 [공유하기]로 저장할 수 있어
               방해 없이 콘텐츠를 읽을 수 있어요
               """
      case .onboarding5:
        return
               """
               PC와 모바일 어디서든 연결되는
               나만의 콘텐츠 아카이빙 공간
               """
      }
    }
    
    var image: Image {
      switch self {
      case .onboarding1:
        return CommonFeature.Images.onBoarding1
      case .onboarding2:
        return CommonFeature.Images.onBoarding2
      case .onboarding3:
        return CommonFeature.Images.onBoarding3
      case .onboarding4:
        return CommonFeature.Images.onBoarding4
      case .onboarding5:
        return CommonFeature.Images.onBoarding5
      }
    }
    
    var indicatorImage: Image {
      switch self {
      case .onboarding1:
        return CommonFeature.Images.onBoardingIndicator1
      case .onboarding2:
        return CommonFeature.Images.onBoardingIndicator2
      case .onboarding3:
        return CommonFeature.Images.onBoardingIndicator3
      case .onboarding4:
        return CommonFeature.Images.onBoardingIndicator4
      case .onboarding5:
        return CommonFeature.Images.onBoardingIndicator5
      }
    }
  }
}
