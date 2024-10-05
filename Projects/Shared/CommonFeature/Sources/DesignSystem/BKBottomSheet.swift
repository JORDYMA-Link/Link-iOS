//
//  BKBottomSheet.swift
//  CommonFeature
//
//  Created by 김규철 on 5/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import Common

import ComposableArchitecture

public extension View {
  func bottomSheet<Content: View>(
    isPresented: Binding<Bool>,
    currentDetent: Binding<PresentationDetent>? = nil,
    detents: Set<PresentationDetent>,
    leadingTitle: String,
    closeButtonAction: (() -> Void)? = nil,
    isBackgroundBlack: Bool = true,
    isDismissible: Bool = true,
    sheetContent: @escaping () -> Content
  ) -> some View {
    modifier(
      BKBottomSheetModifier(
        isPresented: isPresented,
        currentDetent: currentDetent,
        detents: detents,
        isDismissible: isDismissible,
        isBackgroundBlack: isBackgroundBlack,
        leadingTitle: leadingTitle,
        closeButtonAction: closeButtonAction,
        sheetContent: sheetContent
      )
    )
  }
}

fileprivate struct BKBottomSheetModifier<SheetContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  fileprivate var currentDetent: Binding<PresentationDetent>?
  fileprivate let detents: Set<PresentationDetent>
  fileprivate let isDismissible: Bool
  fileprivate let isBackgroundBlack: Bool
  fileprivate let leadingTitle: String
  fileprivate let closeButtonAction: (() -> Void)?
  
  fileprivate let sheetContent: () -> SheetContent
  
  func body(content: Content) -> some View {
    ZStack {
      if isBackgroundBlack {
        Color.bkColor(.gray900)
          .ignoresSafeArea()
          .zIndex(1)
          .opacity(isPresented ? 0.6 : 0)
          .animation(.easeOut, value: isPresented)
      }
      
      content
        .sheet(isPresented: $isPresented) {
          WithPerceptionTracking {
            VStack(spacing: 0) {
              navBar
              sheetContent()
            }
            .if(currentDetent == nil) { view in
              view.presentationDetents(detents)
            }
            .ifLet(currentDetent) { view, currentDetent in
              view.presentationDetents(detents, selection: currentDetent)
            }
          }
        }
    }
  }
  
  @ViewBuilder
  private var navBar: some View {
    HStack(spacing: 12) {
      BKText(
        text: leadingTitle,
        font: .semiBold,
        size: ._16,
        lineHeight: 24,
        color: .bkColor(.black)
      )
      .frame(maxWidth: .infinity, alignment: .leading)
      
      BKIcon(
        image: CommonFeature.Images.icoClose,
        color: .bkColor(.gray900),
        size: .init(width: 24, height: 24)
      )
      .onTapGesture {
        closeButtonAction?()
        
        if isDismissible {
          isPresented = false
        }
      }
    }
    .padding(.horizontal, 20)
    .frame(minHeight: 56, maxHeight: 56)
  }
}
