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
  private var onWillDisappear: (Feed) -> Void
  
  @StateObject private var scrollViewDelegate = ScrollViewDelegate()
  @StateObject private var bkWebViewModel = BKWebViewModel()
  
  @State private var isScrollDetected: Bool = false
  @FocusState private var isContentFocused: Bool
  @FocusState private var isMemoFocused: Bool
  
  init(
    store: StoreOf<LinkFeature>,
    onWillDisappear: @escaping (Feed) -> Void
  ) {
    self.store = store
    self.onWillDisappear = onWillDisappear
  }
  
  var body: some View {
    WithPerceptionTracking {
      ScrollView(showsIndicators: false) {
        VStack(spacing: 0) {
          LinkHeaderView(store: store)
            .background(ViewMaxYGeometry())
            .onPreferenceChange(ViewPreferenceKey.self) { maxY in
              let headerMaxY = maxY + UIApplication.topSafeAreaInset
              
              DispatchQueue.main.async {
                scrollViewDelegate.headerMaxY = headerMaxY
              }
            }
          
          VStack(alignment: .leading, spacing: 0) {
            switch store.linkType {
            case .feedDetail, .summarySave:
              contentHeaderView
              
              BKChipView(
                keywords: .constant(store.feed.keywords),
                chipType: .default,
                designType: .main
              )
              .padding(.top, 6)
              
              contentTextView
                .padding(.top, 8)
                            
              folderTitle
                .padding(.top, 16)
              
              folderSection
                .padding(.top, 8)
              
              memoHeaderView
                .padding(.top, 16)
              
              memoTextView
                .padding(.top, 13)
              
            case .summaryCompleted:
              folderTitle
              
              folderSection
                .padding(.top, 8)
              
              contentHeaderView
                .padding(.top, 16)
              
              WithPerceptionTracking {
                BKChipView(
                  keywords: $store.feed.keywords,
                  chipType: store.isContentUpdatable ? .default : .addWithDelete,
                  designType: .main,
                  deleteAction: {
                    HapticFeedbackManager.shared.impact(style: .light)
                    store.send(.chipItemDeleteButtonTapped($0), animation: .default)
                  },
                  addAction: {
                    HapticFeedbackManager.shared.impact(style: .light)
                    store.send(.chipItemAddButtonTapped)
                  }
                )
                .padding(.top, 6)
              }
              
              contentTextView
                .padding(.top, 8)
                            
              memoHeaderView
                .padding(.top, 16)
              
              memoTextView
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
              store: store,
              isScrollDetected: $isScrollDetected
            )
            .offset(y: -minY)
          }
        }
      }
      .introspect(.scrollView, on: .iOS(.v16, .v17, .v18)) { scrollView in
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
        saveAction: {
          HapticFeedbackManager.shared.notification(type: .success)
          store.send(.clipboardPopupSaveButtonTapped)
        }
      )
      .toast(
        isPresented: $store.isClipboardToastPresented,
        toastType: .clipboard,
        toastContent: { BKClipboardToast() }
      )
      .fullScreenCover(
        isPresented: $store.isOriginUrlPresented) {
          if let url = URL(string: store.feed.originUrl) {
            BKContainerWebView(url: url)
          }
        }
        .fullScreenCover(
          item: $store.scope(
            state: \.editLink,
            action: \.editLink)
        ) { store in
          WithPerceptionTracking {
            EditLinkView(store: store)
          }
        }
        .bkWebViewAlert(
          isPresented: $store.isWebViewPresented) {
            BKWebView(
              viewModel: bkWebViewModel,
              url: URL(string: store.webViewInfo.link)!,
              isScrollEnabled: false
            ) { action in
              switch action {
              case .survey(.closeSurveyModal):
                store.send(.closeBKWebView)
                
              case .survey(.openSurveyForm(let url)):
                store.send(.openSurveyFormButtonTapped(url))
              }
            }
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
            isPresented: $store.addFolderBottomSheet.isAddFolderBottomSheetPresented,
            detents: [.height(202 - UIApplication.bottomSafeAreaInset)],
            leadingTitle: "폴더 추가",
            closeButtonAction: { store.send(.addFolderBottomSheet(.closeButtonTapped)) }
          ) {
            AddFolderBottomSheet(store: store.scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet))
              .interactiveDismissDisabled()
          }
          .bottomSheet(
            isPresented: $store.addKeywordBottomSheet.isAddKewordBottomSheetPresented,
            detents: [.height(240 - UIApplication.bottomSafeAreaInset)],
            leadingTitle: "키워드 추가",
            closeButtonAction: { store.send(.addKeywordBottomSheet(.closeButtonTapped)) }
          ) {
            AddKewordBottomSheet(store: store.scope(state: \.addKeywordBottomSheet, action: \.addKeywordBottomSheet))
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
              action: {
                HapticFeedbackManager.shared.selection()
                store.send(.menuBottomSheet($0))
              }
            )
          }
          .tapToHideKeyboard()
          .onChange(of: store.isContentUpdatable) { isContentUpdatable in
            isContentFocused = !isContentUpdatable
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
  private var contentHeaderView: some View {
    switch store.linkType {
    case .feedDetail, .summarySave:
      BKText(
        text: "요약 내용",
        font: .semiBold,
        size: ._18,
        lineHeight: 26,
        color: .bkColor(.gray900)
      )
      
    case .summaryCompleted:
      HStack {
        BKText(
          text: "요약 내용",
          font: .semiBold,
          size: ._18,
          lineHeight: 26,
          color: .bkColor(.gray900)
        )
        
        Spacer()
        
        LinkUpdateButton(
          isUpdatable: store.state.isContentUpdatable,
          type: .content,
          action: {store.send(.contentUpdateButtonTapped) }
        )
      }
    }
  }
  
  @ViewBuilder
  private var contentTextView: some View {
    switch store.linkType {
    case .feedDetail, .summarySave:
      LinkTextView(content: store.feed.summary)
      
    case .summaryCompleted:
      WithPerceptionTracking {
        LinkTextField(
          content: $store.feed.summary,
          isFocused: _isContentFocused,
          type: .content,
          isDisabled: store.state.isContentUpdatable
        )
      }
    }
  }
  
  @ViewBuilder
  private var folderTitle: some View {
    switch store.linkType {
    case .feedDetail, .summarySave:
      BKText(
        text: "폴더",
        font: .semiBold,
        size: ._18,
        lineHeight: 26,
        color: .bkColor(.gray900)
      )
      
    case .summaryCompleted:
      VStack(alignment: .leading, spacing: 0) {
        HStack(spacing: 0) {
          BKText(
            text: "AI 추천 폴더",
            font: .semiBold,
            size: ._18,
            lineHeight: 26,
            color: .bkColor(.gray900)
          )
          
          CommonFeature.Images.icoConceptStar
            .resizable()
            .scaledToFill()
            .frame(width: 20, height: 20)
        }
        
        BKText(
          text: "AI가 링크 내용 기반으로 추천한 폴더입니다.",
          font: .regular,
          size: ._12,
          lineHeight: 18,
          color: .bkColor(.gray600)
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
          action: {
            HapticFeedbackManager.shared.selection()
            store.send(.recommendFolderItemTapped, animation: .default)
          }
        )
        
        BKText(
          text: "직접 폴더 설정",
          font: .semiBold,
          size: ._18,
          lineHeight: 26,
          color: .bkColor(.gray900)
        )
        .padding(.top, 6)
        
        BKAddFolderList(
          folderItemType: .default,
          folderList: store.feed.folders ?? [],
          selectedFolder: store.selectedFolder,
          itemAction: {
            HapticFeedbackManager.shared.selection()
            store.send(.folderItemTapped($0), animation: .default)
          },
          addAction: {
            HapticFeedbackManager.shared.selection()
            store.send(.addFolderItemTapped, animation: .default)
          }
        )
        .padding(.horizontal, -16)
      }
    }
  }
  
  @ViewBuilder
  private var memoHeaderView: some View {
    BKText(
      text: "메모",
      font: .semiBold,
      size: ._18,
      lineHeight: 26,
      color: .bkColor(.gray900)
    )
    .opacity((store.linkType != .summaryCompleted && store.feed.memo.isEmpty) ? 0 : 1)
  }
  
  @ViewBuilder
  private var memoTextView: some View {
    switch store.linkType {
    case .feedDetail, .summarySave:
      LinkTextView(content: store.feed.memo)
        .opacity(store.feed.memo.isEmpty ? 0 : 1)
      
    case .summaryCompleted:
      WithPerceptionTracking {
        LinkTextField(
          content: $store.feed.memo,
          isFocused: _isMemoFocused,
          type: .memo,
          placeholder: "메모를 작성해주세요.",
          isDisabled: false
        )
      }
    }
  }
  
  @ViewBuilder
  private var bottomSafeAreaButton: some View {
    switch store.linkType {
    case .feedDetail, .summarySave:
      BKRoundedButton(title: "원문 보기", confirmAction: {
        HapticFeedbackManager.shared.impact(style: .light)
        store.send(.showURLButtonTapped)
      })
    case .summaryCompleted:
      HStack(spacing: 8) {
        BKRoundedButton(buttonType: .gray, title: "삭제", confirmAction: {
          HapticFeedbackManager.shared.impact(style: .medium)
          store.send(.summaryDeleteButtonTapped)
        })
        
        BKRoundedButton(buttonType: .main, title: "저장하기", confirmAction: {
          HapticFeedbackManager.shared.impact(style: .medium)
          store.send(.summarySaveButtonTapped)
        })
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
