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
    WithPerceptionTracking {
      Group {
        if store.folderFeedList.isEmpty {
          emptyView()
        } else {
          contentView()
        }
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
        WithPerceptionTracking {
          BKCardCell(
            sourceTitle: item.platform,
            sourceImage: item.platformImage,
            isMarked: item.isMarked,
            saveAction: { store.send(.cardItemSaveButtonTapped(index, !item.isMarked), animation: .default) },
            menuAction: { store.send(.cardItemMenuButtonTapped(item)) },
            title: item.title,
            description: item.summary,
            keyword: item.keywords
          )
          .onTapGesture { store.send(.cardItemTapped(item.feedId)) }
          .onAppear {
            if index != 0 && item == store.folderFeedList.last && !store.fetchedAllFeedCards {
              store.send(.pagination)
            }
          }
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.bottom, 20)
  }
}

