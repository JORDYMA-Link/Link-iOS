//
//  LinkContentView.swift
//  Features
//
//  Created by kyuchul on 7/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models
import Common

import ComposableArchitecture
import SwiftUIIntrospect

struct LinkContentView: View {
  @Bindable var store: StoreOf<LinkContentFeature>
  @StateObject var scrollViewDelegate = ScrollViewDelegate()
  @State private var isScrolled: Bool = false
  
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(spacing: 0) {
        LinkContentHeaderView(
          link: LinkDetail.mock(),
          saveAction: {
            print("save")
          }, shareAction: {
            print("share")
          })
        .background(ViewHeightGeometry())
        .onPreferenceChange(SectionHeaderPreferenceKey.self) { maxY in
          let headerMaxY = maxY + UIApplication.topSafeAreaInset
          
          DispatchQueue.main.async {
            scrollViewDelegate.headerMaxY = headerMaxY
          }
        }
        
        VStack(alignment: .leading, spacing: 0) {
          BKText(
            text: "요약 내용",
            font: .semiBold,
            size: ._18,
            lineHeight: 26,
            color: .bkColor(.gray900)
          )
          
          LinkContentTextView(content: "지난 22일 러시아 모스크바 시내 공연장에서 발생한 총기 난사 사건 사망자가 최소 115명으로 늘었으며 당국에 의해 11명이 체포됐다고 23일 AP통신이 보도했다. AP는 러시아 수사 위원회를 인용해 115명을 숨지게한 이번 총격 테러와 관련돼 11명이 체")
            .padding(.top, 6)
          
          BKChipView(
            keyword: LinkDetail.mock().keywords,
            textColor: .bkColor(.gray700),
            strokeColor: .bkColor(.gray500),
            font: .semiBold(size: ._11)
          )
          .padding(.top, 8)
          
          LinkContentTitleButton(
            title: "폴더",
            buttonTitle: "수정",
            action: {}
          )
          .padding(.top, 16)
          
          Spacer()
          
          LinkContentTitleButton(
            title: "메모",
            buttonTitle: "수정",
            action: {}
          )
          .padding(.top, 16)
          
          LinkContentTextView(content: "지난 22일 러시아 모스크바 시내 공연장에서 발생한 총기 난사 사건 사망자가 최소 115명으로 늘었으며 당국에 의해 11명이 체포됐다고 23일 AP통신이 보도했다. AP는 러시아 수사 위원회를 인용해 115명을 숨지게한 이번 총격 테러와 관련돼 11명이 체지난 22일 러시아 모스크바 시내 공연장에서 발생한 총기 난사 사건 사망자가 최소 115명으로 늘었으며 당국에 의해 11명이 체포됐다고 23일 AP통신이 보도했다. AP는 러시아 수사 위원회를 인용해 115명을 숨지게한 이번 총격 테러와 관련돼 11명이 체지난 22일 러시아 모스크바 시내 공연장에서 발생한 총기 난사 사건 사망자가 최소 115명으로 늘었으며 당국에 의해 11명이 체포됐다고 23일 AP통신이 보도했다. AP는 러시아 수사 위원회를 인용해 115명을 숨지게한 이번 총격 테러와 관련돼 11명이 체지난 22일 러시아 모스크바 시내 공연장에서 발생한 총기 난사 사건 사망자가 최소 115명으로 늘었으며 당국에 의해 11명이 체포됐다고 23일 AP통신이 보도했다. AP는 러시아 수사 위원회를 인용해 115명을 숨지게한 이번 총격 테러와 관련돼 11명이 체지난 22일 러시아 모스크바 시내 공연장에서 발생한 총기 난사 사건 사망자가 최소 115명으로 늘었으며 당국에 의해 11명이 체포됐다고 23일 AP통신이 보도했다. AP는 러시아 수사 위원회를 인용해 115명을 숨지게한 이번 총격 테러와 관련돼 11명이 체")
            .padding(.top, 13)
        }
        .padding(.top, 24)
        .padding(.horizontal, 16)
      }
      .overlay(alignment: .top) {
        GeometryReader { proxy in
          let minY = proxy.frame(in: .global).minY
          LinkContentNavigationBar(
            isScrolled: $isScrolled,
            title: LinkDetail.mock().title,
            leftAction: { store.send(.closeButtonTapped) },
            rightAction: {}
          )
          .offset(y: -minY)
        }
      }
    }
    .introspect(.scrollView, on: .iOS(.v17)) { scrollView in
      scrollView.delegate = scrollViewDelegate
    }
    .ignoresSafeArea()
    .toolbar(.hidden, for: .navigationBar)
    .animation(.easeInOut, value: isScrolled)
    .onReceive(scrollViewDelegate.$topToHeader.receive(on: DispatchQueue.main)) {
      self.isScrolled = $0
    }
    
    BKRoundedButton(title: "원문 보기", confirmAction: {})
      .padding(.all, 10)
      .background(.white)
  }
}

#Preview {
  NavigationStack {
    LinkContentView(store: .init(initialState: LinkContentFeature.State()) {
      LinkContentFeature()
    })
  }
}
