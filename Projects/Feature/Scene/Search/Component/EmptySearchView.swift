//
//  EmptySearchView.swift
//  Features
//
//  Created by kyuchul on 7/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

struct EmptySearchView: View {
  @Perception.Bindable private var store: StoreOf<SearchFeature>
  
  init(store: StoreOf<SearchFeature>) {
    self.store = store
  }
  
  var body: some View {
    WithPerceptionTracking {
      VStack(alignment: .center, spacing: 0) {
        Spacer()
        
        CommonFeature.Images.icoEmptySearch
        
          SearchResultTitle(keyword: store.keyword, title: "에 대한 검색 결과가 없습니다.", isEmpty: true)
            .padding(.bottom, 4)
        
        BKText(
          text: "검색어를 다시 입력해주세요",
          font: .regular,
          size: ._12,
          lineHeight: 18,
          color: .bkColor(.gray700)
        )
        .lineLimit(1)
        
        Spacer()
      }
      .padding(.horizontal, 56)
    }
  }
}
