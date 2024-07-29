//
//  LinkMenuBottomSheet.swift
//  Features
//
//  Created by kyuchul on 6/23/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

struct LinkMenuBottomSheet: View {
  @Bindable var store: StoreOf<LinkMenuBottomSheetFeature>
  
    var body: some View {
      HStack(spacing:0) {
        VStack(alignment: .leading, spacing: 8) {
          makeMenuButton(title: "수정하기", action: { store.send(.menuTapped(.editLinkPost)) })
          makeMenuButton(title: "삭제하기", isEdit: false, action: { store.send(.menuTapped(.deleteLinkPost)) })
          
          Spacer()
        }
        
        Spacer(minLength: 0)
      }
    }
  
  @ViewBuilder
  private func makeMenuButton(title: String, isEdit: Bool = true, action: @escaping (() -> Void)) -> some View {
    Button {
      action()
    } label: {
      Text(title)
        .font(.regular(size: ._16))
        .foregroundStyle(Color.bkColor(isEdit ? .gray900 : .red))
        .padding(.vertical, 8)
    }
  }
}
