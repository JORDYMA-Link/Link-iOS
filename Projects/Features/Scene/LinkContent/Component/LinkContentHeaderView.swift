//
//  LinkContentHeaderView.swift
//  Features
//
//  Created by kyuchul on 7/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models
import Common

import SwiftUIIntrospect

struct LinkContentHeaderView: View {
  private let link: LinkDetail
  private let saveAction: () -> Void
  private let shareAction: () -> Void
  @State private var height: CGFloat = 0
  
  init(
    link: LinkDetail,
    saveAction: @escaping () -> Void,
    shareAction: @escaping () -> Void
  ) {
    self.link = link
    self.saveAction = saveAction
    self.shareAction = shareAction
  }
  
  var body: some View {
    GeometryReader { proxy in
      let size = proxy.size
      let minY = proxy.frame(in: .global).minY
      let isScrolling = minY > 0
      
      CommonFeature.Images.contentDetailBackground
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: size.width, height: size.height + (isScrolling ? minY : 0))
        .clipped()
        .offset(y: isScrolling ? -minY : 0)
        .overlay(alignment: .top) {
          VStack(spacing: 0) {
            titleView(link: link)
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
  private func titleView(link: LinkDetail) -> some View {
    HStack(spacing: 0) {
      VStack(alignment: .leading, spacing: 0) {
        CommonFeature.Images.icoBellClick
          .resizable()
          .frame(width: 24, height: 24)
        
        Text(link.title)
          .font(.regular(size: ._28))
          .foregroundColor(Color.bkColor(.white))
          .lineLimit(3)
          .multilineTextAlignment(.leading)
          .padding(.top, 4)
          .frame(maxWidth: .infinity, minHeight: Size.titleMinHeight, alignment: .topLeading)
          .fixedSize(horizontal: false, vertical: true)
          .background(
            GeometryReader { proxy in
              Color.clear.onAppear { self.height = proxy.size.height }
            }
          )
        
        Text(link.date)
          .font(.regular(size: ._16))
          .foregroundColor(Color.bkColor(.white))
          .lineHeight(font: .regular(size: ._16), lineHeight: 24)
      }
      
      Spacer(minLength: 0)
    }
  }
  
  private var buttonView: some View {
    HStack(spacing: 20) {
      Spacer(minLength: 0)
      
      Button {
        saveAction()
      } label: {
        BKIcon(
          image: CommonFeature.Images.icoSave,
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

extension LinkContentHeaderView {
  private struct Size {
    static let topSafeAreaInset: CGFloat = UIApplication.topSafeAreaInset
    static let navigationBarHeight: CGFloat = 56
    static let titleMinHeight: CGFloat = 76
    static let headerMaxHeight: CGFloat = topSafeAreaInset + 266
    static let headerMinHeight: CGFloat = topSafeAreaInset + 239
  }
}
