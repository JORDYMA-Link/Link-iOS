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
  ///링크 저장 프로모션 상세 페이지
  case linkSavePromotionDetail
  /// 링크 저장 프로모션 인증 페이지
  case linkSavePromotionVerify
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
        color: chevronRightIconColor,
        size: CGSize(width: 20, height: 20)
      )
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 12)
    .frame(minWidth: 74, maxHeight: 74)
    .background(backgroundColor)
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
        color: subTitleColor
      )
      .lineLimit(1)
      
      BKText(
        text: title,
        font: .semiBold,
        size: ._14,
        lineHeight: 18,
        color: titleColor
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
      
    case .linkSavePromotionDetail:
      CommonFeature.Images.promotionDetailBannerIcon
      
    case .linkSavePromotionVerify:
      CommonFeature.Images.promotionVerifyBannerIcon
    }
  }
  
  var subTitle: String {
    switch type {
    case .instruction:
      "알면 알수록 똑똑한 앱, 블링크"
      
    case .kakaoChannel:
      "서비스 이용에 불편이 있나요?"
      
    case .linkSavePromotionDetail:
      "링크 5개 저장하면, 5천 원!"
      
    case .linkSavePromotionVerify:
      "저장 챌린지 참여하셨다면"
    }
  }
  
  var title: String {
    switch type {
    case .instruction:
      "100% 활용하는 방법 확인하기"
      
    case .kakaoChannel:
      "톡상담으로 빠르게 해결하기"
      
    case .linkSavePromotionDetail:
      "5일 저장 챌린지 참여하고 상품 받아가자!"
      
    case .linkSavePromotionVerify:
      "이제 마지막 참여 인증하러 가볼까요?"
    }
  }
  
  var subTitleColor: Color {
    switch type {
    case .linkSavePromotionVerify:
      return .white
      
    default:
      return .bkColor(.gray800)
    }
  }
  
  var titleColor: Color {
    switch type {
    case .linkSavePromotionVerify:
      return .white
      
    default:
      return .bkColor(.main300)
    }
  }
  
  var chevronRightIconColor: Color {
    switch type {
    case .linkSavePromotionVerify:
      return .white
      
    default:
      return .bkColor(.gray600)
    }
  }
  
  var backgroundColor: Color {
    switch type {
    case .linkSavePromotionVerify:
      return .bkColor(.main300)
      
    default:
      return .bkColor(.gray300)
    }
  }
}

public extension BannerItem {
  static func getPromotionBannerItems() -> [BannerItem] {
    let now = Date()
    let calendar = Calendar.current
    
    func date(_ month: Int, _ day: Int) -> Date? {
      let currentYear = Calendar.current.component(.year, from: Date())
      return calendar.date(from: DateComponents(year: currentYear, month: month, day: day))
    }
    
    var banners: [BannerItem] = []
    
    // 날짜별 로직
    guard
      let detailStart = date(7, 14),
      let detailEnd = date(7, 27),
      let verifyStart = date(7, 18),
      let verifyEnd = date(7, 31) else {
      return banners
    }
    
    let isDetailActive = now >= detailStart && now <= detailEnd
    let isVerifyActive = now >= verifyStart && now <= verifyEnd
    
    if isVerifyActive {
      banners.append(.init(type: .linkSavePromotionVerify))
    }
    
    if isDetailActive {
      banners.append(.init(type: .linkSavePromotionDetail))
    }
    
    // 기본 배너
    banners += [
      .init(type: .instruction),
      .init(type: .kakaoChannel)
    ]
    
    return banners
  }
}
