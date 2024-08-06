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
        isPresented: $store.isMenuBottomSheetPresented,
        detents: [.height(192)],
        leadingTitle: "설정"
      ) {
        BKMenuBottomSheet(
          menuItems: [.editLinkContent, .editFolder, .deleteLinkContent],
          action: { store.send(.menuBottomSheet($0)) }
        )
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
