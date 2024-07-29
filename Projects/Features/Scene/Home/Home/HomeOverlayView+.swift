//
//  HomeOverlayView+.swift
//  Features
//
//  Created by kyuchul on 7/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

extension View {
  @ViewBuilder
  func cardSettingBottomSheet(store: StoreOf<HomeFeature>) -> some View {
    @Bindable var store = store
    self
      .bottomSheet(
        isPresented: $store.linkMenuBottomSheet.isMenuBottomSheetPresented,
        detents: [.height(144)],
        leadingTitle: "설정",
        closeButtonAction: { store.send(.linkMenuBottomSheet(.closeButtonTapped)) }
      ) {
        LinkMenuBottomSheet(store: store.scope(state: \.linkMenuBottomSheet, action: \.linkMenuBottomSheet))
          .padding(.horizontal, 16)
      }
  }
  
  @ViewBuilder
  func editFolderBottomSheet(store: StoreOf<HomeFeature>) -> some View {
    @Bindable var store = store
    self
      .bottomSheet(
        isPresented: $store.editFolderBottomSheet.isEditFolderBottomSheetPresented,
        detents: [.height(132)],
        leadingTitle: "폴더 수정",
        closeButtonAction: { store.send(.editFolderBottomSheet(.closeButtonTapped)) }
      ) {
        EditFolderBottomSheet(store: store.scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet))
          .interactiveDismissDisabled()
      }
  }
}
