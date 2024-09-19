//
//  HomeContainerView.swift
//  Features
//
//  Created by kyuchul on 7/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

struct HomeContainerView<Content: View>: View {
  private let store: StoreOf<HomeFeature>
  private let tabbar: () -> Content
  @Binding private var isSummaryToastPresented: Bool
  @Binding private var summaryType: SummaryType
  private let toastAction: () -> Void
  
  
  public init(
    store: StoreOf<HomeFeature>,
    tabbar: @autoclosure @escaping () -> Content,
    isSummaryToastPresented: Binding<Bool>,
    summaryType: Binding<SummaryType>,
    toastAction: @escaping () -> Void
  ) {
    self.store = store
    self.tabbar = tabbar
    self._isSummaryToastPresented = isSummaryToastPresented
    self._summaryType = summaryType
    self.toastAction = toastAction
  }
  
  var body: some View {
    WithPerceptionTracking {
      ZStack(alignment: .bottom) {
        HomeView(store: store)
          .toast(
            isPresented: $isSummaryToastPresented,
            toastType: .summary,
            toastContent: {
              BKSummaryToast(
                summaryType: $summaryType,
                action: { toastAction() }
              )
            }
          )
        
        tabbar()
      }
      .cardSettingBottomSheet(store: store)
      .editFolderBottomSheet(store: store)
      .addFolderBottomSheet(store: store)
      .editLinkFullScreenOver(store: store)
      .toolbar(.hidden, for: .navigationBar)
    }
  }
}
