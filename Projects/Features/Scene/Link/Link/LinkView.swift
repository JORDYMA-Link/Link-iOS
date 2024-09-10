//
//  LinkView.swift
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

struct LinkView: View {
  @Perception.Bindable var store: StoreOf<LinkFeature>
  @StateObject var scrollViewDelegate = ScrollViewDelegate()
  @State private var isScrollDetected: Bool = false
  private var onWillDisappear: (Feed) -> Void
  
  init(store: StoreOf<LinkFeature>,
       onWillDisappear: @escaping (Feed) -> Void
  ) {
    self.store = store
    self.onWillDisappear = onWillDisappear
  }
  
  var body: some View {
    WithPerceptionTracking {
      ScrollView(showsIndicators: false) {
        VStack(spacing: 0) {
          LinkHeaderView(
            feed: store.feed,
            saveAction: { store.send(.saveButtonTapped($0)) },
            shareAction: { store.send(.shareButtonTapped) }
          )
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
            
            LinkTextView(content: store.feed.summary)
              .padding(.top, 6)
            
            BKChipView(
              keywords: .constant(store.feed.keywords),
              chipType: .default
            )
            .padding(.top, 8)
            
            folderTitle
              .padding(.top, 16)
            
            folderSection
              .padding(.top, 8)
            
            LinkTitleButton(
              title: "메모",
              buttonTitle: store.memoButtonTitle,
              action: {
                store.send(.editMemoButtonTapeed)
              }
            )
            .padding(.top, 16)
            
            if !store.feed.memo.isEmpty {
              LinkTextView(content: store.feed.memo)
                .padding(.top, 13)
            }
          }
          .padding(.top, 24)
          .padding(.horizontal, 16)
        }
        .overlay(alignment: .top) {
          GeometryReader { proxy in
            let minY = proxy.frame(in: .global).minY
            LinkNavigationBar(
              isScrollDetected: $isScrollDetected,
              title: store.feed.title,
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
        bottomSafeAreaButton
          .padding([.top, .horizontal], 10)
          .background(.white)
      }
      .ignoresSafeArea(edges: .top)
      .toolbar(.hidden, for: .navigationBar)
      .animation(.easeInOut, value: isScrollDetected)
      .linkPopGestureOnlyDisabled(store.linkType)
      .clipboardPopup(
        isPresented: $store.isClipboardPopupPresented,
        urlString: store.feed.originUrl,
        saveAction: { store.send(.clipboardPopupSaveButtonTapped) }
      )
      .toast(
        isPresented: $store.isClipboardToastPresented,
        toastType: .clipboard,
        toastContent: { BKClipboardToast() }
      )
      .fullScreenCover(
        isPresented: $store.isWebViewPresented) {
          if let url = URL(string: store.feed.originUrl) {
            BKContainerWebView(url: url)
          }
        }
      .fullScreenCover(
        item: $store.scope(
          state: \.editLink,
          action: \.editLink)
      ) { store in
        EditLinkView(store: store)
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
          menuItems: [.editLink, .deleteLink],
          action: { store.send(.menuBottomSheet($0)) }
        )
      }
      .onReceive(scrollViewDelegate.$isScrollDetected.receive(on: DispatchQueue.main)) {
        self.isScrollDetected = $0
      }
      .task { await store.send(.onTask).finish() }
      .onWillDisappear {
        // FeedDetail에서만 스와이프백이 가능하기 때문에 WillDisappear 시 부모뷰 업데이트
        if store.linkType == .feedDetail {
          onWillDisappear(store.feed)
        }
      }
    }
  }
  
  @ViewBuilder
  private var folderTitle: some View {
    switch store.linkType {
    case .feedDetail, .summarySave:
      LinkTitleButton(
        title: "폴더",
        buttonTitle: "수정",
        action: { store.send(.editFolderButtonTapped) }
      )
    case .summaryCompleted:
      HStack(spacing: 0) {
        CommonFeature.Images.icoConceptStar
          .resizable()
          .scaledToFill()
          .frame(width: 20, height: 20)
        
        LinkTitleButton(
          title: "추천 폴더",
          buttonTitle: "선택사항",
          action: {}
        )
      }
    }
  }
  
  @ViewBuilder
  private var folderSection: some View {
    switch store.linkType {
    case .feedDetail, .summarySave:
      BKFolderItem(
        folderItemType: .default,
        title: store.feed.folderName,
        isSeleted: false,
        action: {}
      )
    case .summaryCompleted:
      VStack(alignment: .leading, spacing: 10) {
        BKFolderItem(
          folderItemType: .default,
          title: store.feed.folderName,
          isSeleted: store.feed.folderName == store.selectedFolder,
          action: { store.send(.recommendFolderItemTapped) }
        )
        
        BKAddFolderList(
          folderItemType: .default,
          folderList: store.feed.recommendFolders ?? [],
          selectedFolder: store.selectedFolder,
          itemAction: { store.send(.folderItemTapped($0)) },
          addAction: { store.send(.addFolderItemTapped) }
        )
        .padding(.horizontal, -16)
      }
    }
  }
  
  @ViewBuilder
  private var bottomSafeAreaButton: some View {
    switch store.linkType {
    case .feedDetail, .summarySave:
      BKRoundedButton(title: "원문 보기", confirmAction: { store.send(.showURLButtonTapped) })
    case .summaryCompleted:
      HStack(spacing: 8) {
        BKRoundedButton(buttonType: .gray, title: "내용 수정", confirmAction: { store.send(.summaryEditButtonTapped) })
        BKRoundedButton(buttonType: .main, title: "확인", confirmAction: { store.send(.summarySaveButtonTapped) })
      }
    }
  }
}

private extension View {
  @ViewBuilder
  func linkPopGestureOnlyDisabled(_ type: LinkType) -> some View {
    if type != .feedDetail {
      self
        .popGestureOnlyDisabled()
    } else {
      self
    }
  }
}
