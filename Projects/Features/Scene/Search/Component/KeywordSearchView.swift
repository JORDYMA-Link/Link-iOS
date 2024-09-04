//
//  KeywordSearchView.swift
//  Features
//
//  Created by kyuchul on 7/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Models
import CommonFeature

import ComposableArchitecture

struct KeywordSearchView: View {
  @Perception.Bindable private var store: StoreOf<SearchFeature>
  
  init(store: StoreOf<SearchFeature>) {
    self.store = store
  }
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 0) {
        SearchResultTitle(keyword: store.keyword, title: "검색 결과")
          .padding(.bottom, 24)
        
        LazyVStack(spacing: 32) {
          ForEach(store.section) { section in
            LazyVStack(spacing: 20) {
              ForEach(section.searchList) { item in
                BKCardCell(
                  sourceTitle: item.source,
                  sourceImage: "",
                  isMarked: item.isMarked,
                  saveAction: {},
                  menuAction: {},
                  title: item.title,
                  description: item.summary,
                  keyword: item.keywords,
                  isUncategorized: false
                )
              }
              
              KeywordSearchListFooterView(
                keyword: store.keyword,
                section: section,
                footerMoreAction: { section in store.send(.seeMoreButtonTapped(section), animation: .spring) }
              )
            }
          }
        }
      }
      .padding(EdgeInsets(top: 20, leading: 16, bottom: 90, trailing: 16))
    }
  }
}

extension KeywordSearchView {
  private struct KeywordSearchListFooterView: View {
    private let keyword: String
    private let section: SearchKeywordSection
    private let footerMoreAction: (SearchKeywordSection) -> Void
    
    init(
      keyword: String,
      section: SearchKeywordSection,
      footerMoreAction: @escaping (SearchKeywordSection) -> Void
    ) {
      self.keyword = keyword
      self.section = section
      self.footerMoreAction = footerMoreAction
    }
    
    var body: some View {
      VStack(spacing: 16) {
        SearchResultTitle(keyword: keyword, title: "검색 결과 더보기")
        
        if !section.isSeeMoreButtonHidden {
          BKText(
            text: "더보기",
            font: .semiBold,
            size: ._16,
            lineHeight: 18,
            color: .bkColor(.gray900)
          )
          .frame(width: 110)
          .padding(.vertical, 7)
          .padding(.horizontal, 12)
          .background(
            RoundedRectangle(cornerRadius: 9)
              .fill(Color.bkColor(.gray500))
          )
          .onTapGesture { footerMoreAction(section) }
        }
      }
    }
  }
}
