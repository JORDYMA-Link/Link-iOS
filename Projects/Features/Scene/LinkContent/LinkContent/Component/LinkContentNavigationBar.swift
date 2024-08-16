//
//  LinkContentNavigationBar.swift
//  Features
//
//  Created by kyuchul on 7/7/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature
import Common

struct LinkContentNavigationBar: View {
  @Binding var isScrollDetected: Bool
  private let title: String
  private let leftAction: () -> Void
  private let rightAction: () -> Void
  
  init(
    isScrollDetected: Binding<Bool>,
    title: String,
    leftAction: @escaping () -> Void,
    rightAction: @escaping () -> Void
  ) {
    self._isScrollDetected = isScrollDetected
    self.title = title
    self.leftAction = leftAction
    self.rightAction = rightAction
  }
  
  var body: some View {
    VStack(spacing: 0) {
      Spacer(minLength: 0)
      
      HStack(spacing: 0) {
        Button {
          leftAction()
        } label: {
          BKIcon(
            image: CommonFeature.Images.icoChevronLeft,
            color: isScrollDetected ? .black : .white,
            size: CGSize(width: 24, height: 24)
          )
        }
        
        Text(title)
          .foregroundStyle(Color.black)
          .font(.semiBold(size: ._16))
          .lineLimit(1)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding(.leading, 4)
          .opacity(isScrollDetected ? 1 : 0)
        
        Spacer(minLength: 0)
        
        Button {
          rightAction()
        } label: {
          BKIcon(
            image: CommonFeature.Images.icoMoreVertical,
            color: isScrollDetected ? .black : .white,
            size: CGSize(width: 24, height: 24)
          )
        }
      }
      .padding(.horizontal, 16)
      
      Spacer(minLength: 0)
      
      Divider()
        .foregroundStyle(Color.bkColor(.gray400))
        .frame(maxWidth: .infinity)
        .opacity(isScrollDetected ? 1 : 0)
    }
    .frame(height: 56)
    .padding(.top, UIApplication.topSafeAreaInset)
    .background(isScrollDetected ? Color.white : Color.clear)
  }
}
