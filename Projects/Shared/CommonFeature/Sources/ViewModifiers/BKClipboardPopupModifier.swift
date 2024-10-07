//
//  BKClipboardPopupModifier.swift
//  CommonFeature
//
//  Created by kyuchul on 8/16/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

private struct BKClipboardPopupModifier: ViewModifier {
  @Binding var isPresented: Bool
  private var urlString: String
  private var saveAction: (() -> Void)?
  
  init(
    isPresented: Binding<Bool>,
    urlString: String,
    saveAction: (() -> Void)? = nil
  ) {
    self._isPresented = isPresented
    self.urlString = urlString
    self.saveAction = saveAction
  }
  
  func body(content: Content) -> some View {
    content
      .overlay(
        ZStack {
          if isPresented {
            VStack {
              Spacer()
              
              BKClipboardPopup(
                urlString: urlString,
                closeAction: { hidePopup() },
                copyAction: {
                  saveClipboard()
                  saveAction?()
                  hidePopup()
                }
              )
              
              Spacer()
              Spacer()
            }
            .padding(.horizontal, 16)
          }
        }
          .animation(.easeInOut, value: isPresented)
      )
  }
  
  private func saveClipboard() {
    UIPasteboard.general.string = urlString
  }
  
  private func hidePopup() {
    isPresented = false
  }
}

public extension View {
  func clipboardPopup(
    isPresented: Binding<Bool>,
    urlString: String,
    saveAction: (() -> Void)? = nil
  ) -> some View {
    modifier(BKClipboardPopupModifier(
      isPresented: isPresented,
      urlString: urlString,
      saveAction: saveAction)
    )
  }
}
