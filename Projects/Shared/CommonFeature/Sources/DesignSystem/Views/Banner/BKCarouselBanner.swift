//
//  BKCarouselBanner.swift
//  CommonFeature
//
//  Created by kyuchul on 12/22/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

/// iOS 18.0 이상 Carousel 사용 시 
@available(iOS 18.0, *)
public struct BKCarouselBanner: View {
  @State private var activePage: Int = 0
  private var bannerItems: [BannerItem] = [
    .init(type: .instruction),
    .init(type: .kakaoChannel)
  ]
  
  public init() {}
  
  public var body: some View {
    BKCarousel(activeIndex: $activePage) {
      ForEach(bannerItems) { item in
        BKBannerItem(type: item.type)
          .padding(.horizontal, 1)
      }
    }
    .frame(height: 74)
    .clipShape(RoundedRectangle(cornerRadius: 10))
    .overlay(alignment: .bottom) {
      BKPageControl(
        pageItems: bannerItems,
        activeIndex: $activePage
      )
      .padding(.bottom, 6)
    }
  }
}

private struct BKPageControl: View {
  private let pageItems: [BannerItem]
  @Binding private var activeIndex: Int
  
  init(
    pageItems: [BannerItem],
    activeIndex: Binding<Int>
  ) {
    self.pageItems = pageItems
    self._activeIndex = activeIndex
  }
  
  var body: some View {
    HStack {
      ForEach(pageItems.indices, id: \.self) { index in
        Circle()
          .fill(Color.bkColor(activeIndex == index ? .gray900 : .gray600))
          .frame(width: 4, height: 4)
      }
    }
    .animation(.snappy, value: activeIndex)
  }
}
