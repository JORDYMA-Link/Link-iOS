//
//  StorageBoxContentListView.swift
//  Blink
//
//  Created by 김규철 on 5/5/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct StorageBoxContentListView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var contentText: String = ""
    
    var body: some View {
        VStack {
            TextField("콘텐츠를 찾아드립니다.", text: $contentText)
                .frame(height: 43)
                .background(Color.bkColor(.gray300))
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
            
            GeometryReader { proxy in
                VStack(spacing: 0) {
                    makeContentListHeaderView(title: "꽁꽁얼어붙은")
                        .padding(.top, 20)
                        .padding(.bottom, 16)
                    
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 20) {
                            ForEach(1...10, id: \.self) { count in
                                BKCardCell(width: proxy.size.width - 32, sourceTitle: "브런치", sourceImage: CommonFeatureAsset.Images.graphicBell.swiftUIImage, saveAction: {}, menuAction: {}, title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"])
                            }
                        }
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 16)
                .background(Color.bkColor(.gray300))
            }
        }
        .background(Color.bkColor(.white))
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                LeadingItem(type: .tab("보관함"))
            }
        }
    }
    
    @ViewBuilder
    private func makeContentListHeaderView(title: String) -> some View {
        HStack(spacing: 8) {
            Button(action: { dismiss() }) {
                BKIcon(image: CommonFeatureAsset.Images.icoChevronLeft.swiftUIImage, color: .bkColor(.gray900), size: CGSize(width: 24, height: 24))
            }
            
            Text(title)
                .font(.semiBold(size: ._16))
                .foregroundStyle(Color.bkColor(.gray900))
                .lineLimit(1)
            
            Spacer(minLength: 0)
            
            Button(action: {}) {
                makeCategoryView(categoryTitle: "최신순")
            }
        }
    }
    
    @ViewBuilder
    private func makeCategoryView(categoryTitle: String) -> some View {
        HStack(spacing: 0) {
            Text(categoryTitle)
                .font(.regular(size: ._13))
                .foregroundStyle(Color.bkColor(.gray700))
            BKIcon(image: CommonFeatureAsset.Images.icoChevronDown.swiftUIImage, color: .bkColor(.gray700), size: CGSize(width: 16, height: 16))
        }
    }
}

#Preview {
    StorageBoxContentListView()
}
