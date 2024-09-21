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
    WithPerceptionTracking {
      ScrollView(showsIndicators: false) {
        VStack(alignment: .leading, spacing: 0) {
          SearchResultTitle(keyword: store.keyword, title: "검색 결과")
            .padding(.bottom, 24)
          
          LazyVStack(spacing: 32) {
            ForEach(Array(store.feedSection.enumerated()), id: \.element.id) { sectionIndex, section in
              LazyVStack(spacing: 20) {
                ForEach(Array(section.result.enumerated()), id: \.element.feedId) { index, item in
                  WithPerceptionTracking {
                    BKCardCell(
                      sourceTitle: item.platform,
                      sourceImage: item.platformImage,
                      isMarked: item.isMarked,
                      saveAction: { store.send(.keywordSearchItemSaveButtonTapped(sectionIndex: sectionIndex, index: index, isMarked: !item.isMarked, feedId: item.feedId)) },
                      menuAction: { store.send(.keywordSearchMenuButtonTapped(sectionIndex: sectionIndex, index: index, feed: item)) },
                      title: item.title,
                      description: item.summary,
                      highlightedWord: store.keyword,
                      keyword: item.keywords,
                      isUncategorized: false
                    )
                    .onTapGesture { store.send(.keywordSearchItemTapped(sectionIndex: sectionIndex, index: index, feed: item)) }
                  }
                }
                
                if !section.isLast {
                  KeywordSearchListFooterView(
                    keyword: store.keyword,
                    section: section,
                    footerMoreAction: { section in store.send(.footerPaginationButtonTapped(sectionIndex), animation: .spring)
                    }
                  )
                }
              }
              
              if section.isLast {
                Spacer()
              }
            }
          }
        }
        .padding(EdgeInsets(top: 20, leading: 16, bottom: 90, trailing: 16))
      }
    }
  }
}

private extension KeywordSearchView {
  struct KeywordSearchListFooterView: View {
    private let keyword: String
    private let section: SearchFeed
    private let footerMoreAction: (SearchFeed) -> Void
    
    init(
      keyword: String,
      section: SearchFeed,
      footerMoreAction: @escaping (SearchFeed) -> Void
    ) {
      self.keyword = keyword
      self.section = section
      self.footerMoreAction = footerMoreAction
    }
    
    var body: some View {
      VStack(spacing: 16) {
        SearchResultTitle(keyword: keyword, title: "검색 결과 더보기")
        
        if section.isPagination {
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
