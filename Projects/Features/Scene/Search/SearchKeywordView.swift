//
//  SearchKeywordView.swift
//  Blink
//
//  Created by kyuchul on 6/9/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture

struct SearchKeywordView: View {
  @Perception.Bindable var store: StoreOf<SearchKeywordFeature>
  @FocusState private var textIsFocused: Bool
  
  var body: some View {
    WithPerceptionTracking {
      ZStack(alignment: .top) {
        Color.bkColor(.gray300).ignoresSafeArea(edges: .bottom)
        
        VStack(spacing: 0) {
          SearchKeywordNavigationBar(
            text: $store.text,
            textIsFocused: _textIsFocused,
            searchAction: { store.send(.searchButtonTapped(store.text), animation: .spring) },
            dismiss: { store.send(.closeButtonTapped) }
          )
          
          Divider()
            .foregroundStyle(Color.bkColor(.gray400))
          
          if store.keyword.isEmpty {
            RecentSearchView(
              resentSearches: store.recentSearches,
              removeAllAction: { store.send(.removeAllRecentSearchesButtonTapeed, animation: .spring) },
              removeAction: { keyword in store.send(.removeRecentSearchesCellTapeed(keyword), animation: .spring) },
              recentSearchAction: {keyword in store.send(.searchButtonTapped(keyword), animation: .spring) }
            )
          } else if store.section.isEmpty {
            EmptySearchView(keyword: store.keyword)
          } else {
            KeywordSearchListView(
              keyword: store.keyword,
              searches: store.section,
              saveAction: {},
              menuAction: {},
              moreAction: { section in store.send(.seeMoreButtonTapped(section), animation: .spring) }
            )
          }
        }
      }
      .toolbar(.hidden, for: .navigationBar)
      .task { await store.send(.onTask).finish() }
      .onAppear { textIsFocused = true }
    }
  }
}

extension SearchKeywordView {
  private struct SearchKeywordNavigationBar: View {
    @Binding var text: String
    @FocusState var textIsFocused
    private let searchAction: () -> Void
    private let dismiss: () -> Void
    
    init(
      text: Binding<String>,
      textIsFocused: FocusState<Bool>,
      searchAction: @escaping () -> Void,
      dismiss: @escaping () -> Void
    ) {
      self._text = text
      self._textIsFocused = textIsFocused
      self.searchAction = searchAction
      self.dismiss = dismiss
    }
    
    
    var body: some View {
      HStack(spacing: 8) {
        BKIcon(
          image: CommonFeature.Images.icoChevronLeft,
          color: .bkColor(.gray900),
          size: CGSize(width: 24, height: 24)
        )
        .onTapGesture { dismiss() }
        
        BKSearchTextField(
          text: $text,
          textFieldType: .searchKeyword,
          height: 43
        )
        .focused($textIsFocused)
        .onSubmit {
          textIsFocused = false
          searchAction()
        }
      }
      .padding(EdgeInsets(top: 12, leading: 16, bottom: 24, trailing: 16))
      .background(Color.white)
    }
  }
}

