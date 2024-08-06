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
        .background(ViewMaxYGeometry())
        .onPreferenceChange(ViewPreferenceKey.self) { maxY in
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
            action: { store.send(.editFolderButtonTapped) }
          )
          .padding(.top, 16)
          
          BKText(
            text: LinkDetail.mock().folderName,
            font: .regular,
            size: ._14,
            lineHeight: 20,
            color: .bkColor(.gray900)
          )
          .padding(EdgeInsets(top: 9, leading: 13, bottom: 9, trailing: 13))
          .background(
            RoundedRectangle(cornerRadius: 8)
              .fill(Color.white)
              .stroke(Color.bkColor(.gray500), lineWidth: 1)
              .padding(1)
          )
          .padding(.top, 8)
          
          LinkContentTitleButton(
            title: "메모",
            buttonTitle: store.memoButtonTitle,
            action: {
              store.send(.editMemoButtonTapeed)
            }
          )
          .padding(.top, 16)
          
          if !store.memo.isEmpty {
            LinkContentTextView(content: store.memo)
              .padding(.top, 13)
          }
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
            rightAction: { store.send(.menuButtonTapped) }
          )
          .offset(y: -minY)
        }
      }
    }
    .introspect(.scrollView, on: .iOS(.v17)) { scrollView in
      scrollView.delegate = scrollViewDelegate
    }
    .safeAreaInset(edge: .bottom, spacing: 0) {
      BKRoundedButton(title: "원문 보기", confirmAction: {})
        .padding([.top, .horizontal], 10)
        .background(.white)
    }
    .ignoresSafeArea(edges: .top)
    .toolbar(.hidden, for: .navigationBar)
    .animation(.easeInOut, value: isScrolled)
    .onReceive(scrollViewDelegate.$topToHeader.receive(on: DispatchQueue.main)) {
      self.isScrolled = $0
    }
    .fullScreenCover(
      item: $store.scope(
        state: \.editLinkContent,
        action: \.editLinkContent)
    ) { store in
      EditLinkContentView(store: store)
    }
    .bottomSheet(
      isPresented: $store.editFolderBottomSheet.isEditFolderBottomSheetPresented,
      detents: [.height(132)],
      leadingTitle: "폴더 수정",
      closeButtonAction: { store.send(.editFolderBottomSheet(.closeButtonTapped)) }
    ) {
      EditFolderBottomSheet(store: store.scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet))
    }
    .bottomSheet(
      isPresented: $store.editMemoBottomSheet.isEditMemoBottomSheetPresented,
      detents: [.height(292 - UIApplication.bottomSafeAreaInset)],
      leadingTitle: "메모",
      closeButtonAction: { store.send(.editMemoBottomSheet(.closeButtonTapped)) }
    ) {
      EditMemoBottomSheet(store: store.scope(state: \.editMemoBottomSheet, action: \.editMemoBottomSheet))
    }
    .bottomSheet(
      isPresented: $store.isMenuBottomSheetPresented,
      detents: [.height(144)],
      leadingTitle: "설정"
    ) {
      BKMenuBottomSheet(
        menuItems: [.editLinkContent, .deleteLinkContent],
        action: { store.send(.menuBottomSheet($0)) }
      )
    }
  }
}
