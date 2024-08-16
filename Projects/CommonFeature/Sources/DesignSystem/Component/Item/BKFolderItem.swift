//
//  BKFolderCell.swift
//  CommonFeature
//
//  Created by kyuchul on 7/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public enum FolderItemType {
  case summaryCompleted
  case addFolderBottomSheet
  
  var font: BKFont {
    switch self {
    case .summaryCompleted:
      return .regular
    case .addFolderBottomSheet:
      return .semiBold
    }
  }
  
  var size: CGFloat.Size {
    switch self {
    case .summaryCompleted:
      return ._14
    case .addFolderBottomSheet:
      return ._16
    }
  }
  
  var lineHeight: CGFloat {
    switch self {
    case .summaryCompleted:
      return 20
    case .addFolderBottomSheet:
      return 24
    }
  }
  
  var verticalPadding: CGFloat {
    switch self {
    case .summaryCompleted:
      return 9
    case .addFolderBottomSheet:
      return 13
    }
  }
    
  var horizontalPadding: CGFloat {
    switch self {
    case .summaryCompleted:
      return 13
    case .addFolderBottomSheet:
      return 15
    }
  }
  
  var cornerRadius: CGFloat {
    switch self {
    case .summaryCompleted:
      return 8
    case .addFolderBottomSheet:
      return 10
    }
  }
}

public struct BKFolderItem: View {
  private let folderItemType: FolderItemType
  private var title: String
  private let isSeleted: Bool
  private let action: () -> Void
  
  public init(
    folderItemType: FolderItemType,
    title: String,
    isSeleted: Bool,
    action: @escaping () -> Void
  ) {
    self.folderItemType = folderItemType
    self.title = title
    self.isSeleted = isSeleted
    self.action = action
  }
  
  public var body: some View {
    BKText(
      text: title,
      font: folderItemType.font,
      size: folderItemType.size,
      lineHeight: folderItemType.lineHeight,
      color: isSeleted ? .white : .bkColor(.gray600)
    )
    .padding(.vertical, folderItemType.verticalPadding)
    .padding(.horizontal, folderItemType.horizontalPadding)
    .background(
      RoundedRectangle(cornerRadius: folderItemType.cornerRadius)
        .fill(Color.bkColor(isSeleted ? .main300 : .gray300))
    )
    .overlay {
      RoundedRectangle(cornerRadius: folderItemType.cornerRadius)
        .stroke(Color.bkColor(isSeleted ? .main300 : .gray500), lineWidth: 1)
        .padding(1)
    }
    .onTapGesture { action() }
  }
}

