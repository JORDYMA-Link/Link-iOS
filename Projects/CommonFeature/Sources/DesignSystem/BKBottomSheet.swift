//
//  BKBottomSheet.swift
//  CommonFeature
//
//  Created by 김규철 on 5/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import Common

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

struct BKBottomSheetModifier<SheetContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  var currentDetent: Binding<PresentationDetent>?
  let detents: Set<PresentationDetent>
  let isDismissible: Bool
  let isBackgroundBlack: Bool
  let leadingTitle: String
  let closeButtonAction: (() -> Void)?
  
  let sheetContent: () -> SheetContent
  
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
          VStack(spacing: 0) {
            makeBKNavigationView(leadingType: .pop(leadingTitle), trailingType: .pop(action: {
              closeButtonAction?()
              if isDismissible {
                isPresented = false
              }
            }))
            
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
