//
//  EditFolderBottomSheet.swift
//  Features
//
//  Created by kyuchul on 6/23/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture

struct EditFolderBottomSheet: View {
  @Perception.Bindable var store: StoreOf<EditFolderBottomSheetFeature>
  
  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        BKAddFolderList(
          folderList: store.folderList,
          selectedFolder: store.selectedFolder,
          itemAction: { store.send(.folderCellTapped($0), animation: .default) },
          addAction: { store.send(.addFolderBottomSheet(.addFolderTapped), animation: .default) }
        )
        .padding(.vertical, 12)
        .frame(height: 76)
        
        Spacer()
      }
      .ignoresSafeArea(edges: .bottom)
      .sheet(isPresented: $store.addFolderBottomSheet.isAddFolderBottomSheetPresented) {
        makeAddFolderBottomSheet()
          .presentationDetents([.height(202)])
      }
      .task { await store.send(.onTask).finish() }
    }
  }
  
  @ViewBuilder
  private func makeAddFolderBottomSheet() -> some View {
    VStack(spacing: 0) {
      makeBKNavigationView(leadingType: .pop("폴더 추가"), trailingType: .pop(action: {
        hideKeyboard()
        store.send(.addFolderBottomSheet(.closeButtonTapped))}))
      
      AddFolderBottomSheet(store: store.scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet))
    }
  }
}
