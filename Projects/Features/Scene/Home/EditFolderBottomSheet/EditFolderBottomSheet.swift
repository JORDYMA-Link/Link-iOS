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
  @Bindable var store: StoreOf<EditFolderBottomSheetFeature>
  
  var body: some View {
    VStack(spacing: 0) {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 10) {
          ForEach(Array(store.folderList.enumerated()), id: \.offset) { index, folder in
            BKFolderItem(
              title: folder.title,
              isSeleted: store.seletedFolder == folder,
              action: { store.send(.folderCellTapped(folder), animation: .default) }
            )
          }
          
          BKAddFolderItem(
            action: { store.send(.addFolderBottomSheet(.addFolderTapped), animation: .default) }
          )
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
      }
      .frame(height: 76)
      
      Spacer()
    }
    .ignoresSafeArea(edges: .bottom)
    .sheet(isPresented: $store.addFolderBottomSheet.isAddFolderBottomSheetPresented) {
      makeAddFolderBottomSheet()
        .presentationDetents([.height(202)])
    }
    .task {
      await store
        .send(._onTask)
        .finish()
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
