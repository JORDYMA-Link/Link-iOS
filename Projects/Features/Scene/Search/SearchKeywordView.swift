//
//  SearchKeywordView.swift
//  Blink
//
//  Created by kyuchul on 6/9/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

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
                                    ForEach(1...10, id: \.self) { count in
                                        BKCardCell(width: geometry.size.width - 32, sourceTitle: "브런치", sourceImage: CommonFeature.Images.graphicBell, saveAction: {}, menuAction: {}, title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"], isUncategorized: false)
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
