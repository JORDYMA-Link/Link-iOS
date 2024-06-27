//
//  SearchKeywordView.swift
//  Blink
//
//  Created by kyuchul on 6/9/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature
import CoreKit
import Models

import ComposableArchitecture

struct SearchKeywordView: View {
    @Bindable var store: StoreOf<SearchKeywordFeature>
    
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
                                makeSearchResultTitle("UI/UX")
                                    .padding(.bottom, 24)
                                
                                LazyVStack(spacing: 20) {
                                  ForEach(SearchKeyword.mock(), id: \.self) { item in
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
}
