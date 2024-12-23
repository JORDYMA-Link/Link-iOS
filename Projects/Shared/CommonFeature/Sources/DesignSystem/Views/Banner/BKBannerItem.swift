//
//  BKBannerItem.swift
//  CommonFeature
//
//  Created by kyuchul on 8/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public enum BKBannerType: CaseIterable {
  case instruction
  case kakaoChannel
}

public struct BannerItem: Identifiable, Equatable {
  public var id: String = UUID().uuidString
  public var type: BKBannerType
  
  public init(type: BKBannerType) {
    self.type = type
  }
}

public struct BKBannerItem: View {
  private let type: BKBannerType
  
  public init(type: BKBannerType) {
    self.type = type
  }
  
  public var body: some View {
    HStack(spacing: 0) {
      logo
        .padding(.trailing, 8)
      
      instructionView
        .padding(.trailing, 12)
      
      BKIcon(
        image: CommonFeature.Images.icoChevronRight,
        color: .bkColor(.gray600),
        size: CGSize(width: 20, height: 20)
      )
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .frame(minWidth: 74, maxHeight: 74)
    .background(Color.bkColor(.gray300))
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
  
  private var logo: some View {
    logoImage
      .resizable()
      .scaledToFill()
      .frame(width: 50, height: 50)
  }
  
  private var instructionView: some View {
    VStack(alignment: .leading, spacing: 2) {
      BKText(
        text: subTitle,
        font: .regular,
        size: ._12,
        lineHeight: 18,
        color: .bkColor(.gray800)
      )
      .lineLimit(1)
      
      BKText(
        text: title,
        font: .semiBold,
        size: ._14,
        lineHeight: 18,
        color: .bkColor(.main300)
      )
      .lineLimit(1)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private extension BKBannerItem {
  var logoImage: Image {
    switch type {
    case .instruction:
      CommonFeature.Images.icoCircleAppLogo
      
    case .kakaoChannel:
      CommonFeature.Images.icoCircleKakao
    }
  }
    
  var subTitle: String {
    switch type {
    case .instruction:
      "알면 알수록 똑똑한 앱, 블링크"
      
    case .kakaoChannel:
      "서비스 이용에 불편이 있나요?"
    }
  }
  
  var title: String {
    switch type {
    case .instruction:
      "100% 활용하는 방법 확인하기"
      
    case .kakaoChannel:
      "톡상담으로 빠르게 해결하기"
    }
  }
}
