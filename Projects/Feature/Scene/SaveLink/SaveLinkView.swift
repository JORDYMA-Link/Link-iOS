//
//  SaveLinkView.swift
//  Blink
//
//  Created by 문정호 on 4/29/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import Common
import CommonFeature

import ComposableArchitecture

public struct SaveLinkView: View {
  @Perception.Bindable var store: StoreOf<SaveLinkFeature>
  @Environment(\.dismiss) private var dismiss
  
  public var body: some View {
    WithPerceptionTracking {
      VStack(alignment: .leading, spacing: 0) {
        SaveLinkNavigationBar(store: store)
        
        VStack(alignment: .leading, spacing: 0) {
          HStack(spacing: 0) {
            Text("링크")
              .foregroundStyle(Color.bkColor(.main300))
            Text("를 입력해주세요")
              .foregroundStyle(Color.bkColor(.gray900))
          }
          .font(.semiBold(size: ._24))
          .padding(.bottom, 4)
          
          Text("블링크가 무엇이든 요약해줍니다")
            .frame(alignment: .leading)
            .font(.regular(size: ._14))
            .foregroundStyle(Color.bkColor(.gray700))
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0))
          
          HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading) {
              ClearableTextField(
                text: $store.urlText,
                placeholder: "링크를 붙여주세요"
              )
              .background(Color.bkColor(.white))
              .overlay(
                RoundedRectangle(cornerRadius: 10)
                  .stroke(!store.isValidationURL ? Color.bkColor(.red) : Color.bkColor(.gray500), lineWidth: 1)
              )
              
              if !store.state.isValidationURL {
                Text(store.validationReasonText)
                  .font(.regular(size: ._12))
                  .foregroundStyle(Color.bkColor(.red))
              }
            }
            
            Button {
              HapticFeedbackManager.shared.impact(style: .medium)
              store.send(.onTapNextButton, animation: .default)
              hideKeyboard()
            } label: {
              CommonFeature.Images.icoChevronRight
                .renderingMode(.template)
                .foregroundStyle(store.saveButtonActive ?
                                 Color.bkColor(.white) : Color.bkColor(.gray800))
            }
            .frame(width: 46, height: 46)
            .background(store.saveButtonActive ?
                        Color.bkColor(.main300) : Color.bkColor(.gray300))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!store.saveButtonActive)
          }
          
          SummarizedLinkListView()
            .padding(.top, 24)
          
        }
        .padding(EdgeInsets(top: 28, leading: 16, bottom: 0, trailing: 16))
      }
      .saveLinkBackground()
      .navigationBarBackButtonHidden()
      .toolbar(.hidden, for: .navigationBar)
      .if(store.isLoading) { view in
        view.progressBackground()
      }
      .onAppear { store.send(.onAppear) }
      .fullScreenCover(isPresented: $store.isAdPresented) {
        BKGoogleAdView(
          isPresented: $store.isAdPresented,
          interstitialAd: $store.ad,
          dismissAdScreen: { store.send(.adDismissButtonTapped) }
        )
        .presentationClearBackground()
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
    makeBKNavigationView(leadingType: .dismiss("링크 저장", { store.send(.onTapBackButton) }), trailingType: .none)
      .padding(.leading, 16)
  }
}

private struct SummarizedLinkListView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      titleView
      summarizedLinkList
    }
  }
  
  private var titleView: some View {
    HStack(spacing: 2) {
      BKIcon(
        image: CommonFeature.Images.icoCircleInfo,
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
  private var summarizedLinkList: some View {
    let linkList: [(Image, String)] = [
      (CommonFeature.Images.icoGoogleLogo, "구글"),
      (CommonFeature.Images.icoNaverLogo, "네이버"),
      (CommonFeature.Images.icoMediumLogo, "미디엄"),
      (CommonFeature.Images.icoVelogLogo, "벨로그"),
      (CommonFeature.Images.icoBrunchLogo, "브런치"),
      (CommonFeature.Images.icoThreadsLogo, "쓰레드"),
      (CommonFeature.Images.icoXLogo, "X"),
      (CommonFeature.Images.icoRecentlyITLogo, "요즘IT"),
      (CommonFeature.Images.icoEOLogo, "EO"),
      (CommonFeature.Images.icoTStoryLogo, "티스토리"),
      (CommonFeature.Images.icoTechBlogLogo, "기술블로그")
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

#Preview {
  SaveLinkView(store: .init(initialState: SaveLinkFeature.State(), reducer: {
    SaveLinkFeature()
  }))
}
