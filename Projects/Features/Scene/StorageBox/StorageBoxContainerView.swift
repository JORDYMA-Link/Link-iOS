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
  
  public init(
    store: StoreOf<StorageBoxFeature>,
    tabbar: @autoclosure @escaping () -> Content
  ) {
    self.store = store
    self.tabbar = tabbar
  }
  
  var body: some View {
    NavigationStack {
      ZStack(alignment: .bottom) {
        StorageBoxView(store: store)
        
        tabbar()
      }
      .addFolderBottomSheet(store: store)
      .settingStorageBoxBottomSheet(store: store)
      .editFolderNameBottomSheet(store: store)
      .deleteFolderModal(store: store)
      .toolbar(.hidden, for: .navigationBar)
    }
  }
}
