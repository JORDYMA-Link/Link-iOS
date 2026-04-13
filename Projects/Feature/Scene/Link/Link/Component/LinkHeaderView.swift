//
//  LinkHeaderView.swift
//  Features
//
//  Created by kyuchul on 7/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import BKDesignSystem
import BKModel
import BKCommon

import ComposableArchitecture

struct LinkHeaderView: View {
  @Perception.Bindable private var store: StoreOf<LinkFeature>
  @State private var height: CGFloat = 0
  @FocusState private var titleFocus: Bool
  
  init(store: StoreOf<LinkFeature>) {
    self.store = store
  }
  
  var body: some View {
    WithPerceptionTracking {
      GeometryReader { proxy in
        let size = proxy.size
        let minY = proxy.frame(in: .global).minY
        let isScrolling = minY > 0
        
        Group {
          if !store.feed.thumbnailImage.isEmpty {
            BKImageView(
              imageURL: store.feed.thumbnailImage,
              downsamplingSize: .init(width: size.width, height: size.height),
              placeholder: BKDesignSystem.Images.icoEmptyThumnail
            )
          } else {
            BKDesignSystem.Images.icoEmptyThumnail
              .resizable()
              .scaledToFill()
          }
        }
        .dimmedBackground()
        .frame(width: size.width, height: size.height + (isScrolling ? minY : 0))
        .clipped()
        .offset(y: isScrolling ? -minY : 0)
        .overlay(alignment: .bottom) {
          VStack(spacing: 0) {
            titleView()
            buttonView
          }
          .padding(EdgeInsets(top: Size.topSafeAreaInset + Size.navigationBarHeight, leading: 16, bottom: 24, trailing: 16))
          .offset(y: isScrolling ? -minY : 0)
        }
      }
      .frame(height: height <= Size.titleMinHeight ? Size.headerMinHeight : Size.headerMaxHeight)
      .onChange(of: store.isTitleUpdatable) { isTitleUpdatable in
        titleFocus = !isTitleUpdatable
      }
    }
  }
  
  @MainActor
  private func titleView() -> some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 0) {
        titleHeaderView
        
        titleContentView
        
        BKText(
          text: store.feed.date,
          font: .regular,
          size: ._16,
          lineHeight: 24,
          color: .white
        )
      }
      
      Spacer(minLength: 0)
    }
  }
  
  @ViewBuilder
  private var titleHeaderView: some View {
    BKImageView(
      imageURL: store.feed.platformImage ?? "",
      downsamplingSize: .init(width: 24, height: 24),
      placeholder: BKDesignSystem.Images.icoEmptyPlatform
    )
    .frame(width: 24, height: 24)
    .clipShape(Circle())
  }
  
  @ViewBuilder
  private var titleContentView: some View {
    Group {
      switch store.linkType {
      case .feedDetail, .summarySave:
        Text(store.feed.title)
        
      case .summaryCompleted:
        TextField("", text: $store.feed.title, axis: .vertical)
          .focused($titleFocus)
          .disabled(store.isTitleUpdatable)
          .onChange(of: store.feed.title) { newText in
            if newText.count > 50 {
              store.feed.title = String(newText.prefix(50))
            }
          }
      }
    }
    .foregroundStyle(.white)
    .tint(Color.bkColor(.white))
    .font(.regular(size: ._28))
    .lineLimit(3)
    .multilineTextAlignment(.leading)
    .padding(.top, 4)
    .frame(maxWidth: .infinity, minHeight: 38, alignment: .bottomLeading)
    .fixedSize(horizontal: false, vertical: true)
    .background(ViewHeightGeometry())
    .onPreferenceChange(ViewPreferenceKey.self) { height in
      DispatchQueue.main.async {
        self.height = height
      }
    }
  }
  
  @ViewBuilder
  private var buttonView: some View {
    switch store.linkType {
    case .feedDetail, .summarySave:
      HStack(spacing: 20) {
        Spacer()
        
        Button {
          HapticFeedbackManager.shared.impact(style: .light)
          store.send(.saveButtonTapped(!store.feed.isMarked))
        } label: {
          BKIcon(
            image: store.feed.isMarked ? BKDesignSystem.Images.icoSaveClcik : BKDesignSystem.Images.icoSave,
            color: .white,
            size:CGSize(width: 20, height: 20)
          )
        }
        
        Button {
          HapticFeedbackManager.shared.impact(style: .light)
          store.send(.shareButtonTapped)
        } label: {
          BKIcon(
            image: BKDesignSystem.Images.icoShare,
            color: .white,
            size: CGSize(width: 20, height: 20)
          )
        }
      }
      .frame(minHeight: 20, maxHeight: 20)
      
    case .summaryCompleted:
      HStack {
        Spacer()
        
        LinkUpdateButton(
          isUpdatable: store.state.isTitleUpdatable,
          type: .title,
          action: { store.send(.titleUpdateButtonTapped) }
        )
      }
      .frame(minHeight: 20, maxHeight: 20)
    }
  }
}

extension LinkHeaderView {
  private struct Size {
    static let topSafeAreaInset: CGFloat = UIApplication.topSafeAreaInset
    static let navigationBarHeight: CGFloat = 56
    static let titleMinHeight: CGFloat = 76
    static let headerMaxHeight: CGFloat = 310
    static let headerMinHeight: CGFloat = 272
  }
}
