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
  @Bindable var store: StoreOf<SearchKeywordFeature>
  @FocusState private var textIsFocused: Bool
  
  var body: some View {
    GeometryReader { geometry in
      ZStack {
        Color.bkColor(.gray300).ignoresSafeArea(edges: .bottom)
        
        VStack(spacing: 0) {
          HStack(spacing: 8) {
            makeBackButton()
            makeSearchTextField()
          }
          .padding(EdgeInsets(top: 12, leading: 16, bottom: 24, trailing: 16))
          .background(Color.white)
          
          Divider()
            .foregroundStyle(Color.bkColor(.gray400))
          
          ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
              if !store.section.isEmpty {
                makeSearchResultTitle(store.keyword)
                  .padding(.bottom, 24)
              }
              
              LazyVStack(spacing: 32) {
                ForEach(store.section) { section in
                  LazyVStack(spacing: 20) {
                    ForEach(section.searchList) { item in
                      BKCardCell(
                        width: geometry.size.width - 32,
                        sourceTitle: item.source,
                        sourceImage: CommonFeature.Images.graphicBell,
                        isMarked: item.isMarked,
                        saveAction: {},
                        menuAction: {},
                        title: item.title,
                        description: item.summary,
                        keyword: item.keywords,
                        isUncategorized: false
                      )
                    }
                    
                    makeFooterView(section)
                  }
                }
              }
            }
            .padding(EdgeInsets(top: 20, leading: 16, bottom: 90, trailing: 16))
          }
        }
      }
    }
    .toolbar(.hidden, for: .navigationBar)
  }
}

extension SearchKeywordView {
  @ViewBuilder
  private func makeBackButton() -> some View {
    Button {
      store.send(.closeButtonTapped)
    } label: {
      BKIcon(image: CommonFeature.Images.icoChevronLeft, color: .bkColor(.gray900), size: CGSize(width: 24, height: 24))
    }
  }
  
  @ViewBuilder
  private func makeSearchTextField() -> some View {
    BKSearchTextField(
      text: $store.text,
      textFieldType: .searchKeyword,
      height: 43)
    .onSubmit {
      textIsFocused = false
      store.send(.searchButtonTapped(store.text))
    }
    
  }
  
  @ViewBuilder
  private func makeSearchResultTitle(_ title: String) -> some View {
    HStack(spacing: 4) {
      Text("\"\(title)\"")
        .font(.semiBold(size: ._16))
        .foregroundStyle(Color.bkColor(.main300))
      Text("검색 결과")
        .font(.semiBold(size: ._16))
        .foregroundStyle(Color.bkColor(.gray900))
    }
  }

  @ViewBuilder
  private func makeFooterView(_ section: SearchKeywordSection) -> some View {
    VStack(spacing: 16) {
      HStack(spacing: 0) {
        Text("\(store.keyword) ")
          .foregroundStyle(Color.bkColor(.main300))
          .lineLimit(2)
        Text("검색 결과 더보기")
          .foregroundStyle(Color.bkColor(.gray900))
          .layoutPriority(1)
      }
      .font(.semiBold(size: ._16))
      
      if !section.isSeeMoreButtonHidden {
        Button {
          store.send(.seeMoreButtonTapped(section))
        } label: {
          Text("더보기")
            .foregroundStyle(Color.bkColor(.gray900))
            .font(.semiBold(size: ._16))
            .frame(width: 110)
            .padding(.vertical, 7)
            .padding(.horizontal, 12)
            .background(
              RoundedRectangle(cornerRadius: 9)
                .fill(Color.bkColor(.gray500))
            )
        }
      }
    }
  }
}
