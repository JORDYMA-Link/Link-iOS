//
//  SaveLinkView.swift
//  Blink
//
//  Created by 문정호 on 4/29/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import BKCommon
import BKDesignSystem

import ComposableArchitecture

public struct SaveLinkView: View {
  @Perception.Bindable var store: StoreOf<SaveLinkFeature>
  @Environment(\.dismiss) private var dismiss
  
  public var body: some View {
    GeometryReader { _ in
      WithPerceptionTracking {
        VStack(alignment: .leading, spacing: 24) {
          SaveLinkNavigationBar(store: store)
          
          SaveLinkTitleView()
          
          VStack(alignment: .leading, spacing: 16) {
            SaveLinkTextField(store: store)
            
            if store.isPastoboardButtonPresented {
              SaveLinkPasteboardButton(
                action: { store.send(.pastoboardButtonTapped) }
              )
            }
          }
          
          SaveLinkSummarizedList()
        }
        .padding(.horizontal, 16)
        .saveLinkBackground()
        .toolbar(.hidden, for: .navigationBar)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .tapToHideKeyboard()
        .if(store.isLoading) { view in
          view.progressBackground()
        }
        // MARK: - 광고 관련 로직 임시 제거 (원복 가능하도록 주석 처리)
        // .fullScreenCover(isPresented: $store.isAdPresented) {
        //   WithPerceptionTracking {
        //     BKGoogleAdView(
        //       isPresented: $store.isAdPresented,
        //       interstitialAd: $store.ad,
        //       dismissAdScreen: { store.send(.adDismissButtonTapped) }
        //     )
        //     .presentationClearBackground()
        //   }
        // }
        .animation(.spring, value: store.isPastoboardButtonPresented)
        .onAppear {
          store.send(.onAppear)
        }
      }
    }
  }
}

private struct SaveLinkNavigationBar: View {
  @Perception.Bindable private var store: StoreOf<SaveLinkFeature>
  
  init(store: StoreOf<SaveLinkFeature>) {
    self.store = store
  }
  
  var body: some View {
    makeBKNavigationView(
      leadingType: .dismiss("링크 저장", { store.send(.onTapBackButton) }),
      trailingType: .none
    )
  }
}

private struct SaveLinkTitleView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      titleView
      subTitleView
    }
  }
  
  private var titleView: some View {
    HStack(spacing: 0) {
      BKText(
        text: "링크",
        font: .semiBold,
        size: ._24,
        lineHeight: 34,
        color: .bkColor(.main300)
      )
      
      BKText(
        text: "를 입력해주세요",
        font: .semiBold,
        size: ._24,
        lineHeight: 34,
        color: .bkColor(.gray900)
      )
    }
    .font(.semiBold(size: ._24))
  }
  
  private var subTitleView: some View {
    BKText(
      text: "블링크가 무엇이든 요약해 줍니다",
      font: .regular,
      size: ._14,
      lineHeight: 20,
      color: .bkColor(.gray700)
    )
  }
}

private struct SaveLinkTextField: View {
  @Perception.Bindable private var store: StoreOf<SaveLinkFeature>
  
  init(store: StoreOf<SaveLinkFeature>) {
    self.store = store
  }
  
  var body: some View {
    WithPerceptionTracking {
      HStack(alignment: .top, spacing: 12) {
        WithPerceptionTracking {
          BKTextField(
            text: $store.urlText,
            isValidation: store.state.isValidationURL,
            textFieldType: .saveLink,
            isMultiLine: false,
            isClearButton: true,
            errorMessage: store.state.urlValidation.title,
            height: 46
          )
        }
        
        Button {
          hideKeyboard()
          HapticFeedbackManager.shared.impact(style: .medium)
          store.send(.onTapNextButton, animation: .default)
        } label: {
          buttonView
        }
        .disabled(store.isDisableSaveLinkButton)
      }
    }
  }
  
  
  private var buttonView: some View {
    BKDesignSystem.Images.icoChevronRight
      .renderingMode(.template)
      .foregroundStyle(Color.bkColor(store.isDisableSaveLinkButton ? .gray800 : .white))
      .frame(width: 46, height: 46)
      .background(Color.bkColor(store.isDisableSaveLinkButton ? .gray300 : .main300))
      .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

private struct SaveLinkPasteboardButton: View {
  private let action: () -> Void
  
  init(action: @escaping () -> Void) {
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      BKText(
        text: "복사한 링크 붙여넣기",
        font: .semiBold,
        size: ._14,
        lineHeight: 20,
        color: .bkColor(.main300)
      )
      .padding(.vertical, 10)
      .padding(.horizontal, 14)
      .clipShape(RoundedRectangle(cornerRadius: 100))
      .overlay(
        RoundedRectangle(cornerRadius: 100, style: .continuous)
          .strokeBorder(Color.bkColor(.main300), lineWidth: 1)
      )
    }
  }
}

private struct SaveLinkSummarizedList: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      titleView
      summarizedList
    }
  }
  
  private var titleView: some View {
    HStack(spacing: 2) {
      BKIcon(
        image: BKDesignSystem.Images.icoCircleInfo,
        color: .bkColor(.gray600),
        size: .init(width: 20, height: 20)
      )
      
      BKText(
        text: "요약 가능한 링크",
        font: .semiBold,
        size: ._14,
        lineHeight: 20,
        color: .bkColor(.gray600)
      )
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
  
  @ViewBuilder
  private var summarizedList: some View {
    let linkList: [(Image, String)] = [
      (BKDesignSystem.Images.icoGoogleLogo, "구글"),
      (BKDesignSystem.Images.icoNaverLogo, "네이버"),
      (BKDesignSystem.Images.icoMediumLogo, "미디엄"),
      (BKDesignSystem.Images.icoVelogLogo, "벨로그"),
      (BKDesignSystem.Images.icoBrunchLogo, "브런치"),
      (BKDesignSystem.Images.icoThreadsLogo, "쓰레드"),
      (BKDesignSystem.Images.icoXLogo, "X"),
      (BKDesignSystem.Images.icoRecentlyITLogo, "요즘IT"),
      (BKDesignSystem.Images.icoEOLogo, "EO"),
      (BKDesignSystem.Images.icoTStoryLogo, "티스토리"),
      (BKDesignSystem.Images.icoTechBlogLogo, "기술블로그")
    ]
    
    LazyVGrid(
      columns: [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible())
      ]
    ) {
      ForEach(linkList, id: \.1) { item in
        VStack(alignment: .center, spacing: 4) {
          item.0
            .resizable()
            .scaledToFill()
            .frame(width: 20, height: 20)
          
          BKText(
            text: item.1,
            font: .regular,
            size: ._13,
            lineHeight: 18,
            color: .bkColor(.gray700)
          )
          .lineLimit(1)
          .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
      }
    }
  }
}

private struct SaveLinkLodingView: View {
  var body: some View {
    ZStack {
      Color.black.opacity(0.1)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
      
      ProgressView()
        .controlSize(.large)
        .tint(.bkColor(.gray700))
        .progressViewStyle(.circular)
    }
  }
}

private extension View {
  @ViewBuilder
  func saveLinkBackground() -> some View {
    VStack(spacing: 0) {
      self
      
      Spacer()
    }
  }
  
  @ViewBuilder
  func progressBackground() -> some View {
    ZStack {
      self
      
      SaveLinkLodingView()
    }
  }
}
