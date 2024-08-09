//
//  SortFolderBottomSheet.swift
//  Features
//
//  Created by kyuchul on 6/22/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

struct SortFolderBottomSheet: View {
  @Perception.Bindable var store: StoreOf<SortFolderBottomSheetFeature>
  
  var body: some View {
    WithPerceptionTracking {
      HStack(spacing:0) {
        VStack(alignment: .leading, spacing: 8) {
          ForEach(FolderSortType.allCases, id: \.self) { type in
            makeSortButton(title: type.rawValue, isSelected: type == store.inputSortType) {
              store.send(.sortCellTapped(type))
            }
          }
        }
        Spacer(minLength: 0)
      }
    }
  }
  
  @ViewBuilder
  private func makeSortButton(title: String, isSelected: Bool = true, action: @escaping (() -> Void)) -> some View {
    Button {
      action()
    } label: {
      Text(title)
        .font(.regular(size: ._16))
        .foregroundStyle(Color.bkColor(isSelected ? .black : .gray600))
        .frame(alignment: .leading)
        .padding(.vertical, 8)
    }
  }
}
