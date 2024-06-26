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
            makeFolderCell(
              title: folder.title,
              isSeleted: store.seletedFolder == folder
            )
            .onTapGesture {
              store.send(.folderCellTapped(folder), animation: .default)
            }
          }
          
          makeAddFolderCell()
            .onTapGesture {
              store.send(.addFolderBottomSheet(.addFolderTapped), animation: .default)
            }
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
  private func makeFolderCell(title: String, isSeleted: Bool) -> some View {
    let titleFontHeight = UIFont.semiBold(size: ._16).lineHeight
    
    Text(title)
      .font(.semiBold(size: ._16))
      .foregroundColor(.bkColor(isSeleted ? .white : .gray600))
      .padding(.vertical, ((24 - titleFontHeight) / 2) + 13)
      .padding(.horizontal, 15)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(Color.bkColor(isSeleted ? .main300 : .gray300))
          .stroke(Color.bkColor(isSeleted ? .main300 : .gray500), lineWidth: 1)
          .padding(1)
      )
  }
  
  @ViewBuilder
  private func makeAddFolderCell() -> some View {
    BKIcon(image: CommonFeature.Images.icoPlus, color: .bkColor(.gray600), size: CGSize(width: 20, height: 20))
      .font(.semiBold(size: ._16))
      .padding(.vertical, 13)
      .padding(.horizontal, 15)
      .background(
        RoundedRectangle(cornerRadius: 10)
          .fill(Color.bkColor(.gray300))
          .stroke(Color.bkColor(.gray500), lineWidth: 1)
          .padding(1)
      )
  }
  
  @ViewBuilder
  private func makeAddFolderBottomSheet() -> some View {
    VStack(spacing: 0) {
      makeBKNavigationView(leadingType: .pop("폴더 추가"), trailingType: .pop(action: {
        store.send(.addFolderBottomSheet(.closeButtonTapped))}))
      
      AddFolderBottomSheet(store: store.scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet))
    }
  }
}
