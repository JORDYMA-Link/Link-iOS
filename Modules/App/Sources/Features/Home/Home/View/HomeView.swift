//
//  HomeView.swift
//  Features
//
//  Created by 김규철 on 2024/04/01.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct HomeView: View {
    @StateObject private var viewModel = HomeDIContainer().makeViewModel()
    @State private var categorySelectedIndex: Int? = 0
    @State private var pushToSetting = false
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 12) {
                    useBlinkBanner
                    calendarBanner
                }
                .padding(.init(top: 8, leading: 16, bottom: 24, trailing: 16))
                
                ZStack {
                    Color.bkColor(.gray300)
                    
                    VStack(spacing: 16) {
                        CategoryHorizontalList(selectedIndex: $categorySelectedIndex, categories: ["중요", "미분류"])
                        
                        LazyVStack(spacing: 20) {
                            ForEach(1...10, id: \.self) { count in
                                BKCardCell(width: proxy.size.width - 32, sourceTitle: "브런치", sourceImage: CommonFeatureAsset.Images.graphicBell.swiftUIImage, saveAction: {}, menuAction: {}, title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"])
                            }
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.horizontal, 16)
                }
            }
        }
        .onAppear {
            viewModel.loadCoinData()
        }
        .navigationDestination(isPresented: $pushToSetting) {
            SettingView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                LeadingItem(type: .home)
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                TrailingItem(type: .oneIcon(action: {
                    pushToSetting.toggle()
                }, icon: CommonFeatureAsset.Images.icoSettings.swiftUIImage), tintColor: .bkColor(.gray900))
            }
        }
    }
    
    private var useBlinkBanner: some View {
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
    
    private var calendarBanner: some View {
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
    
    private struct CategoryHorizontalList: View {
        @Binding var selectedIndex: Int?
        var categories: [String]
        
        var body: some View {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    ForEach(categories.indices, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 100)
                                .fill(selectedIndex == index ? Color.black : Color.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(selectedIndex == index ? Color.black : Color.bkColor(.gray500), lineWidth: 1)
                                )
                            
                            Text(categories[index])
                                .font(selectedIndex == index ? .semiBold(size: ._14) : .regular(size: ._14))
                                .foregroundColor(selectedIndex == index ? Color.bkColor(.white) : Color.bkColor(.black))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 14)
                        }
                        .onTapGesture {
                            if selectedIndex == index {
                                selectedIndex = nil
                            } else {
                                selectedIndex = index
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    BKTabView()
}
