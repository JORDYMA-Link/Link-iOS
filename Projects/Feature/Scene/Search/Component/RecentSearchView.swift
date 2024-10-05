//
//  RecentSearchView.swift
//  Features
//
//  Created by kyuchul on 7/25/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

struct RecentSearchView: View {
  @Perception.Bindable private var store: StoreOf<SearchFeature>
  
  init(store: StoreOf<SearchFeature>) {
    self.store = store
  }
  
  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        RecentSearchHeaderView(
          recentSearches: store.recentSearches,
          removeAllAction: { store.send(.removeAllRecentSearchButtonTapped, animation: .spring) }
        )
        
        ScrollView(showsIndicators: false) {
          ForEach(store.recentSearches, id: \.self) { searche in
            WithPerceptionTracking {
              VStack(spacing: 0) {
                HStack {
                  BKText(
                    text: searche,
                    font: .regular,
                    size: ._14,
                    lineHeight: 20,
                    color: .bkColor(.gray900)
                  )
                  .lineLimit(1)
                  
                  Spacer()
                  
                  BKIcon(
                    image: CommonFeature.Images.icoClose,
                    color: .bkColor(.gray700),
                    size: .init(width: 16, height: 16)
                  )
                  .onTapGesture { store.send(.removeRecentSearchButtonTapped(searche), animation: .spring) }
                }
                .padding(16)
                
                Divider()
                  .foregroundStyle(Color.bkColor(.gray400))
              }
              .contentShape(Rectangle())
              .onTapGesture {
                hideKeyboard()
                store.send(.recentSearchItemTapped(searche), animation: .spring)
              }
            }
          }
        }
      }
    }
    .scrollDismissesKeyboard(.interactively)
  }
}

extension RecentSearchView {
  private struct RecentSearchHeaderView: View {
    private let recentSearches: [String]
    private let removeAllAction: () -> Void
    
    init(
      recentSearches: [String],
      removeAllAction: @escaping () -> Void
    ) {
      self.recentSearches = recentSearches
      self.removeAllAction = removeAllAction
    }
    
    var body: some View {
      HStack {
        BKText(
          text: "최근 검색어",
          font: .semiBold,
          size: ._18,
          lineHeight: 26,
          color: .bkColor(.gray900)
        )
        
        Spacer()
        
        if !recentSearches.isEmpty {
          BKText(
            text: "모두 지우기",
            font: .regular,
            size: ._13,
            lineHeight: 18,
            color: .bkColor(.gray700)
          )
          .underline(color: .bkColor(.gray700))
          .onTapGesture { removeAllAction() }
        } else {
          Spacer()
        }
      }
      .padding(16)
    }
  }
}
