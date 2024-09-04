//
//  SearchView.swift
//  Blink
//
//  Created by kyuchul on 6/9/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture

struct SearchView: View {
  @Perception.Bindable var store: StoreOf<SearchFeature>
  @FocusState private var textIsFocused: Bool
  
  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        SearchNavigationBar(
          text: $store.text,
          textIsFocused: _textIsFocused,
          searchAction: { store.send(.searchButtonTapped(store.text)) },
          dismiss: { store.send(.closeButtonTapped) }
        )
        
        Divider()
          .foregroundStyle(Color.bkColor(.gray400))
        
        if store.keyword.isEmpty {
          RecentSearchView(store: store)
        } else if store.section.isEmpty {
          EmptySearchView(store: store)
        } else {
          KeywordSearchView(store: store)
        }
      }
    }
    .searchKeywordBackground()
    .toolbar(.hidden, for: .navigationBar)
    .onAppear { textIsFocused = true }
    .task { await store.send(.onTask).finish() }
  }
}

extension SearchView {
  private struct SearchNavigationBar: View {
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

private extension View {
  @ViewBuilder
  func searchKeywordBackground() -> some View {
    ZStack(alignment: .top) {
      Color.bkColor(.gray300).ignoresSafeArea(edges: .bottom)
      
      self
    }
  }
}
