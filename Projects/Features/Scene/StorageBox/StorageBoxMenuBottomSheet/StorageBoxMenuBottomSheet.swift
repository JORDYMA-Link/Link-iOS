//
//  StorageBoxMenuBottomSheet.swift
//  Features
//
//  Created by kyuchul on 6/18/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

struct StorageBoxMenuBottomSheet: View {
  @Bindable var store: StoreOf<StorageBoxMenuBottomSheetFeature>
  
    var body: some View {
      HStack(spacing:0) {
        VStack(alignment: .leading, spacing: 8) {
          makeMenuButton(title: "폴더 이름 수정하기", action: { store.send(.menuTapped(.editFolderName)) })
          makeMenuButton(title: "폴더 삭제하기", action: { store.send(.menuTapped(.deleteFoler)) })
        }
        Spacer(minLength: 0)
      }
    }
  
  @ViewBuilder
  private func makeMenuButton(title: String, action: @escaping (() -> Void)) -> some View {
    Button {
      action()
    } label: {
      Text(title)
        .font(.regular(size: ._16))
        .foregroundStyle(Color.bkColor(.gray900))
        .padding(.vertical, 8)
    }
  }
}
