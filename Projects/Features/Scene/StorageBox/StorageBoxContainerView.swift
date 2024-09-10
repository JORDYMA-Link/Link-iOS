//
//  StorageBoxContainerView.swift
//  Features
//
//  Created by kyuchul on 7/29/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

struct StorageBoxContainerView<Content: View>: View {
  private let store: StoreOf<StorageBoxFeature>
  private let tabbar: () -> Content
  @Binding var summaryToastIsPresented: Bool
  private let toastAction: () -> Void
  
  
  public init(
    store: StoreOf<StorageBoxFeature>,
    tabbar: @autoclosure @escaping () -> Content,
    summaryToastIsPresented: Binding<Bool>,
    toastAction: @escaping () -> Void
  ) {
    self.store = store
    self.tabbar = tabbar
    self._summaryToastIsPresented = summaryToastIsPresented
    self.toastAction = toastAction
  }
  
  var body: some View {
    WithPerceptionTracking {
      ZStack(alignment: .bottom) {
        StorageBoxView(store: store)
          .toast(
            isPresented: $summaryToastIsPresented,
            toastType: .summary,
            toastContent: {
              BKSummaryToast(
                summaryType: .summaryComplete,
                action: { toastAction() }
              )
            }
          )
        
        tabbar()
      }
      .addFolderBottomSheet(store: store)
      .settingStorageBoxBottomSheet(store: store)
      .editFolderNameBottomSheet(store: store)
      .toolbar(.hidden, for: .navigationBar)
    }
  }
}
