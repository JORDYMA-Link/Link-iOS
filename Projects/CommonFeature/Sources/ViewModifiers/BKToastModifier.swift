//
//  BKToastModifier.swift
//  CommonFeature
//
//  Created by kyuchul on 8/16/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public enum ToastType {
  case clipboard
  case summary
}

private struct BKToastModifier<ToastContent: View>: ViewModifier {
  @Binding var isPresented: Bool
  private let toastType: ToastType
  private let toastContent: () -> ToastContent
  
  init(
    isPresented: Binding<Bool>,
    toastType: ToastType,
    toastContent: @escaping () -> ToastContent
  ) {
    self._isPresented = isPresented
    self.toastType = toastType
    self.toastContent = toastContent
  }
  
  func body(content: Content) -> some View {
    content
      .overlay(
        ZStack {
          if isPresented {
            VStack {
              Spacer()
              
              toastContent()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, padding)
            .task {
              guard toastType == .clipboard else { return }
              
              try? await Task.sleep(for: .seconds(3))
              
              hideToast()
            }
          }
        }
          .ignoresSafeArea()
          .animation(.spring(), value: isPresented)
      )
  }
  
  private func hideToast() {
      isPresented = false
  }
}

private extension BKToastModifier {
  private var padding: CGFloat {
    switch toastType {
    case .clipboard:
      return 70 + UIApplication.bottomSafeAreaInset
    default:
      return 130
    }
  }
}

public extension View {
  func toast<Content: View>(
    isPresented: Binding<Bool>,
    toastType: ToastType,
    toastContent: @escaping () -> Content
  ) -> some View {
    modifier(
      BKToastModifier(
        isPresented: isPresented,
        toastType: toastType,
        toastContent: toastContent
      )
    )
  }
}
