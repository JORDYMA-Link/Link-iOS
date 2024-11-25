//
//  BKCardView.swift
//  Feature
//
//  Created by kyuchul on 10/14/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Services
import Models
import Common
import CommonFeature

import ComposableArchitecture

struct BKCardView: View {
  @Perception.Bindable private var store: StoreOf<BKCardFeature>
  private let emptyTitle: String
  private let emptyHeight: CGFloat
  
  init(
    store: StoreOf<BKCardFeature>,
    emptyTitle: String,
    emptyHeight: CGFloat
  ) {
    self.store = store
    self.emptyTitle = emptyTitle
    self.emptyHeight = emptyHeight
  }
  
  var body: some View {
    Group {
      WithPerceptionTracking {
        if store.isLoading {
          loadingView()
        } else if store.feedList.isEmpty {
          emptyView()
        } else {
          contentSectionView()
        }
      }
    }
  }
  
  @ViewBuilder
  private func loadingView() -> some View {
    BKLoadingIndicator()
      .frame(minHeight: emptyHeight)
      .background(Color.bkColor(.gray300))
  }
  
  @ViewBuilder
  private func emptyView() -> some View {
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
    .frame(minHeight: emptyHeight)
  }
  
  @ViewBuilder
  private func contentSectionView() -> some View {
    ForEach(Array(store.feedList.enumerated()), id: \.offset) { index, item in
      WithPerceptionTracking {
        BKCardCell(
          sourceTitle: item.platform,
          sourceImage: item.platformImage,
          isMarked: item.isMarked,
          saveAction: {
            HapticFeedbackManager.shared.impact(style: .light)
            store.send(.cardItemSaveButtonTapped(index, !item.isMarked), animation: .default)
          },
          menuAction: {
            HapticFeedbackManager.shared.selection()
            store.send(.cardItemMenuButtonTapped(item))
          },
          title: item.title,
          description: item.summary,
          keyword: item.keywords,
          isUncategorized: item.isUnclassified && store.category == .unclassified,
          recommendedFolders: item.recommendedFolder,
          recommendedFolderAction: { store.send(.cardItemRecommendedFolderTapped(item.feedId, $0)) },
          addFolderAction: { store.send(.cardItemAddFolderTapped(item)) }
        )
        .hapticTapGesture(.selection) {
          store.send(.cardItemTapped(item.feedId))
        }
        .onAppear {
          if index != 0 && item == store.feedList.last && !store.fetchedAllFeedCards {
            store.send(.pagination)
          }
        }
      }
    }
  }
}
