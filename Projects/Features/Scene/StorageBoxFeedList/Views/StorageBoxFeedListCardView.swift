//
//  StorageBoxFeedListCardView.swift
//  Features
//
//  Created by kyuchul on 9/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture

struct StorageBoxFeedListCardView: View {
  @Perception.Bindable private var store: StoreOf<StorageBoxFeedListFeature>
  
  init(store: StoreOf<StorageBoxFeedListFeature>) {
    self.store = store
  }
  
  var body: some View {
    Group {
      if store.folderFeedList.isEmpty {
        emptyView()
      } else {
        contentView()
      }
    }
  }
  
  @ViewBuilder
  private func emptyView() -> some View {
    EmptyView()
  }
  
  @ViewBuilder
  private func contentView() -> some View {
    LazyVStack(spacing: 20) {
      ForEach(Array(store.folderFeedList.enumerated()), id: \.element.feedId) { index, item in
        BKCardCell(
          sourceTitle: item.platform,
          sourceImage: item.platformImage,
          isMarked: item.isMarked,
          saveAction: {},
          menuAction: {},
          title: item.title,
          description: item.summary,
          keyword: item.keywords
        )
      }
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 20)
  }
}

