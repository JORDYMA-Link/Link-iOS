//
//  StorageBoxOverlayView+.swift
//  Features
//
//  Created by kyuchul on 7/29/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

extension View {
  @ViewBuilder
  func addFolderBottomSheet(store: StoreOf<StorageBoxFeature>) -> some View {
    @Perception.Bindable var store = store
    
    self
      .bottomSheet(
        isPresented: $store.addFolderBottomSheet.isAddFolderBottomSheetPresented,
        detents: [.height(202 - UIApplication.bottomSafeAreaInset)],
        leadingTitle: "폴더 추가",
        closeButtonAction: { store.send(.addFolderBottomSheet(.closeButtonTapped)) }
      ) {
        AddFolderBottomSheet(store: store.scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet))
          .interactiveDismissDisabled()
      }
  }
  
  @ViewBuilder
  func settingStorageBoxBottomSheet(store: StoreOf<StorageBoxFeature>) -> some View {
    @Perception.Bindable var store = store
    
    self
      .bottomSheet(
        isPresented: $store.isMenuBottomSheetPresented,
        detents: [.height(154)],
        leadingTitle: "폴더 설정"
      ) {
        BKMenuBottomSheet(
          menuItems: [.editFolderName, .deleteFolder],
          action: { store.send(.menuBottomSheet($0)) }
        )
      }
  }
  
  @ViewBuilder
  func editFolderNameBottomSheet(store: StoreOf<StorageBoxFeature>) -> some View {
    @Perception.Bindable var store = store
    
    self
      .bottomSheet(
        isPresented: $store.editFolderNameBottomSheet.isEditFolderBottomSheetPresented,
        detents: [.height(202 - UIApplication.bottomSafeAreaInset)],
        leadingTitle: "폴더 수정",
        closeButtonAction: { store.send(.editFolderNameBottomSheet(.closeButtonTapped)) }
      ) {
        EditFolderNameBottomSheet(store: store.scope(state: \.editFolderNameBottomSheet, action: \.editFolderNameBottomSheet))
          .interactiveDismissDisabled()
      }
  }
}
