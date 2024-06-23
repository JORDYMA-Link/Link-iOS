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
          }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
      }
      .frame(height: 76)
      
      Spacer()
    }
    .ignoresSafeArea(edges: .bottom)
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
}

