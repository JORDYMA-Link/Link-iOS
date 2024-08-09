//
//  BKFolderCell.swift
//  CommonFeature
//
//  Created by kyuchul on 7/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct BKFolderItem: View {
  private var title: String
  private let isSeleted: Bool
  private let action: () -> Void
  private let isBottomSheet: Bool
  
  public init(
    title: String,
    isSeleted: Bool,
    action: @escaping () -> Void,
    isBottomSheet: Bool = true
  ) {
    self.title = title
    self.isSeleted = isSeleted
    self.action = action
    self.isBottomSheet = isBottomSheet
  }
  
  public var body: some View {
    BKText(
      text: title,
      font: isBottomSheet ? .semiBold : .regular,
      size: isBottomSheet ? ._16 : ._14,
      lineHeight: 24,
      color: isSeleted ? .white : .bkColor(.gray600)
    )
    .padding(.vertical, isBottomSheet ? 13 : 9)
    .padding(.horizontal, isBottomSheet ? 15 : 13)
    .background(
      RoundedRectangle(cornerRadius: isBottomSheet ? 10 : 8)
        .fill(Color.bkColor(isSeleted ? .main300 : .gray300))
    )
    .overlay {
      RoundedRectangle(cornerRadius: isBottomSheet ? 10 : 8)
        .stroke(Color.bkColor(isSeleted ? .main300 : .gray500), lineWidth: 1)
    }
    .onTapGesture { action() }
  }
}

