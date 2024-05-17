//
//  HomeView.swift
//  Features
//
//  Created by 김규철 on 2024/04/01.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

import SwiftUIIntrospect

struct HomeView: View {
    @StateObject private var viewModel = HomeDIContainer().makeViewModel()
    @StateObject private var scrollViewDelegate = HomeScrollViewDelegate()
    
    @State private var categorySelectedIndex: Int? = 0
    @State private var topToCategory: Bool = false
    @State private var pushToSetting = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                makeNavigationView()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 12) {
                        makeUseBlinkBanner()
                        makeCalendarBanner()
                    }
                    .padding(.init(top: 8, leading: 16, bottom: 24, trailing: 16))
                    
                    makeArticleListView(geometry)
                }
                .introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
                    scrollView.delegate = scrollViewDelegate
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.loadCoinData()
        }
        .onReceive(scrollViewDelegate.$topToCategory.receive(on: DispatchQueue.main)) { item in
            withAnimation(.easeIn(duration: 0.2)) {
                self.topToCategory = item
            }
        }
        .navigationDestination(isPresented: $pushToSetting) {
            SettingView()
        }
    }
}

extension HomeView {
    @ViewBuilder
    private func makeNavigationView() -> some View {
        makeBKNavigationView(leadingType: .home, trailingType: .oneIcon(action: {
            pushToSetting.toggle()
        }, icon: CommonFeatureAsset.Images.icoSettings.swiftUIImage), tintColor: .bkColor(.gray900))
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private func makeUseBlinkBanner() -> some View {
        HStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(Color.bkColor(.white))
                    .frame(width: 50, height: 50)
                
                CommonFeatureAsset.Images.graphicLogo.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text("알면 알수록 똑똑한 앱, 블링크")
                    .lineLimit(1)
                    .font(.regular(size: ._12))
                    .foregroundStyle(Color.bkColor(.gray800))
                
                Text("100% 활용하는 방법 확인하기")
                    .lineLimit(1)
                    .font(.semiBold(size: ._14))
                    .foregroundStyle(Color.bkColor(.main300))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 8)
            .padding(.trailing, 12)
            
            CommonFeatureAsset.Images.icoChevronRight.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.bkColor(.gray300))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder
    private func makeCalendarBanner() -> some View {
        ZStack {
            Color.bkColor(.gray300)
            
            HStack(spacing: 16) {
                HStack(spacing: 6) {
                    CommonFeatureAsset.Images.icoCalendar.swiftUIImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                    
                    Text("날짜별로 콘텐츠를 찾아드립니다")
                        .lineLimit(1)
                        .font(.regular(size: ._14))
                        .foregroundStyle(Color.bkColor(.gray800))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                CommonFeatureAsset.Images.icoChevronRight.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 13)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder
    private func makeArticleListView(_ geometry: GeometryProxy) -> some View {
        ZStack {
            Color.bkColor(.gray300)
            
            LazyVStack(spacing: 4, pinnedViews: [.sectionHeaders]) {
                Section {
                    ForEach(1...10, id: \.self) { count in
                        BKCardCell(width: geometry.size.width - 32, sourceTitle: "브런치", sourceImage: CommonFeatureAsset.Images.graphicBell.swiftUIImage, saveAction: {}, menuAction: {}, title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"])
                            .padding(.init(top: 0, leading: 16, bottom: 16, trailing: 16))
                    }
                } header: {
                    makeCategorySectionHeader(selectedIndex: $categorySelectedIndex)
                        .background(GeometryReader { proxy in
                            Color.clear.preference(key: CategorySectionHeaderPreferenceKey.self, value: proxy.frame(in: .global).maxY)
                        })
                        .onPreferenceChange(CategorySectionHeaderPreferenceKey.self) { maxY in
                            // 섹션 헤더의 최대 Y 위치 업데이트
                            let navigationBarMaxY = (geometry.safeAreaInsets.top - 20)
                            let headerMaxY = maxY + navigationBarMaxY
                            
                            DispatchQueue.main.async {
                                scrollViewDelegate.headerMaxY = headerMaxY
                            }
                        }
                        .background(topToCategory ? Color.white : Color.bkColor(.gray300))
                        .clipped()
                        .shadow(color: topToCategory ? .bkColor(.gray900).opacity(0.08) : .clear, radius: 5, x: 0, y: 4)
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeCategorySectionHeader(selectedIndex: Binding<Int?>) -> some View {
        var categories = ["중요", "미분류"]
        
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(categories.indices, id: \.self) { index in
                    Text(categories[index])
                        .font(selectedIndex.wrappedValue == index ? .semiBold(size: ._14) : .regular(size: ._14))
                        .foregroundColor(selectedIndex.wrappedValue == index ? Color.white : Color.black)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(selectedIndex.wrappedValue == index ? Color.black : Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(selectedIndex.wrappedValue == index ? Color.clear : Color.bkColor(.gray500), lineWidth: 1)
                                )
                            
                        )
                        .onTapGesture {
                            if selectedIndex.wrappedValue == index {
                                selectedIndex.wrappedValue = nil
                            } else {
                                selectedIndex.wrappedValue = index
                            }
                        }
                }
            }
            .padding(.leading, 16)
        }
        .scrollDisabled(true)
        .padding(.top, 8)
        .padding(.bottom, 12)
    }
}

extension HomeView {
    private struct CategorySectionHeaderPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat = .zero
        
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }
}

#Preview {
    BKTabView()
}


@MainActor
final class HomeScrollViewDelegate: NSObject, UIScrollViewDelegate, ObservableObject {
    @Published var headerMaxY: CGFloat = .zero
    @Published var topToCategory: Bool = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > headerMaxY {
            DispatchQueue.main.async {
                self.topToCategory = true
            }
        } else {
            DispatchQueue.main.async {
                self.topToCategory = false
            }
        }
    }
}
