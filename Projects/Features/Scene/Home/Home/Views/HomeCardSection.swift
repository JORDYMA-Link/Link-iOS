//
//  HomeCardSection.swift
//  Features
//
//  Created by kyuchul on 8/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Services
import Models
import CommonFeature

import ComposableArchitecture

struct HomeCardSection: View {
  @Perception.Bindable private var store: StoreOf<HomeFeature>
  private let emptyHeight: CGFloat
  
  init(
    store: StoreOf<HomeFeature>,
    emptyHeight: CGFloat
  ) {
    self.store = store
    self.emptyHeight = emptyHeight
  }
  
  var body: some View {
    VStack(spacing: 0) {
      if store.feedList.isEmpty {
        emptyView()
      } else {
        contentSectionView()
      }
    }
  }
  
  @ViewBuilder
  private func emptyView() -> some View {
    GeometryReader { proxy in
      VStack(alignment: .center) {
        Spacer()
        
        BKText(
          text: emptyTitle,
          font: .regular,
          size: ._15,
          lineHeight: 22,
          color: .bkColor(.gray600)
        )
        .frame(maxWidth: .infinity)
        .lineLimit(2)
        .multilineTextAlignment(.center)
        .minimumScaleFactor(0.8)
        
        Spacer()
        Spacer()
      }
      .frame(height: emptyHeight)
    }
  }
  
  @ViewBuilder
  private func contentSectionView() -> some View {
    ForEach(store.feedList, id: \.feedId) { item in
      WithPerceptionTracking {
        BKCardCell(
          width: 0,
          sourceTitle:
            item.platform,
          sourceImage: CommonFeature.Images.graphicBell,
          isMarked: true,
          saveAction: {},
          menuAction: { store.send(.cardItemMenuButtonTapped(item)) },
          title: item.title,
          description: item.summary,
          keyword: item.keywords,
          isUncategorized: true,
          recommendedFolders: ["추천폴더1", "추천폴더2", "추천폴더3"],
          recommendedFolderAction: {},
          addFolderAction: {}
        )
        .onTapGesture { store.send(.cardItemTapped(item.feedId)) }
      }
    }
  }
}

private extension HomeCardSection {
  var emptyTitle: String {
    switch store.category {
    case .bookmarked:
      return "북마크된 콘텐츠가 없습니다\n중요한 링크는 북마크하여 바로 확인해보세요"
    case .unclassified:
      return "미분류된 콘텐츠가 없습니다\n분류에 고민이 된다면 미분류의 추천폴더 도움을 받아보세요"
    }
  }
}
