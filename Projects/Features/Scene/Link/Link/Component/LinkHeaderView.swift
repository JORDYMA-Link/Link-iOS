//
//  LinkHeaderView.swift
//  Features
//
//  Created by kyuchul on 7/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature
import Services
import Models
import Common

import SwiftUIIntrospect

struct LinkHeaderView: View {
  private var feed: Feed
  private let saveAction: (Bool) -> Void
  private let shareAction: () -> Void
  @State private var height: CGFloat = 0
  
  init(
    feed: Feed,
    saveAction: @escaping (Bool) -> Void,
    shareAction: @escaping () -> Void
  ) {
    self.feed = feed
    self.saveAction = saveAction
    self.shareAction = shareAction
  }
  
  var body: some View {
    GeometryReader { proxy in
      let size = proxy.size
      let minY = proxy.frame(in: .global).minY
      let isScrolling = minY > 0
      
      BKImageView(
        imageURL: feed.thumbnailImage,
        downsamplingSize: .init(width: size.width, height: size.height),
        placeholder: CommonFeature.Images.icoEmptyThumnail
      )
      .frame(width: size.width, height: size.height + (isScrolling ? minY : 0))
      .clipped()
      .offset(y: isScrolling ? -minY : 0)
      .overlay(alignment: .top) {
        VStack(spacing: 0) {
          titleView()
          Spacer(minLength: 0)
          buttonView
        }
        .padding(EdgeInsets(top: Size.topSafeAreaInset + Size.navigationBarHeight, leading: 16, bottom: 24, trailing: 16))
        .offset(y: isScrolling ? -minY : 0)
      }
    }
    .frame(height: height <= Size.titleMinHeight ? Size.headerMinHeight : Size.headerMaxHeight)
  }
  
  @MainActor
  private func titleView() -> some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 0) {
        BKImageView(
          imageURL: feed.platformImage ?? "",
          downsamplingSize: .init(width: 24, height: 24),
          placeholder: CommonFeature.Images.icoEmptyPlatform
        )
        .frame(width: 24, height: 24)
        
        Text(feed.title)
          .font(.regular(size: ._28))
          .foregroundColor(Color.bkColor(.white))
          .lineLimit(3)
          .multilineTextAlignment(.leading)
          .padding(.top, 4)
          .frame(maxWidth: .infinity, minHeight: Size.titleMinHeight, alignment: .topLeading)
          .fixedSize(horizontal: false, vertical: true)
          .background(ViewHeightGeometry())
          .onPreferenceChange(ViewPreferenceKey.self) { height in
            DispatchQueue.main.async {
              self.height = height
            }
          }
        
        BKText(
          text: feed.date,
          font: .regular,
          size: ._16,
          lineHeight: 24,
          color: .white
        )
      }
      
      Spacer(minLength: 0)
    }
  }
  
  private var buttonView: some View {
    HStack(spacing: 20) {
      Spacer(minLength: 0)
      
      Button {
        saveAction(!feed.isMarked)
      } label: {
        BKIcon(
          image: feed.isMarked ? CommonFeature.Images.icoSaveClcik : CommonFeature.Images.icoSave,
          color: .white,
          size:CGSize(width: 20, height: 20)
        )
      }
      
      Button {
        shareAction()
      } label: {
        BKIcon(
          image: CommonFeature.Images.icoShare,
          color: .white,
          size: CGSize(width: 20, height: 20)
        )
      }
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
