//
//  BKAddFolderItem.swift
//  CommonFeature
//
//  Created by kyuchul on 7/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct BKAddFolderItem: View {
  private let folderItemType: FolderItemType
  private let action: () -> Void
  
  public init(
    folderItemType: FolderItemType,
    action: @escaping () -> Void
  ) {
    self.folderItemType = folderItemType
    self.action = action
  }
  
  public var body: some View {
    BKIcon(
      image: CommonFeature.Images.icoPlus,
      color: .bkColor(.gray600),
      size: CGSize(width: 20, height: 20)
    )
    .padding(.vertical, folderItemType.verticalPadding)
    .padding(.horizontal, folderItemType.horizontalPadding)
    .background(
      RoundedRectangle(cornerRadius: folderItemType.cornerRadius)
        .fill(Color.bkColor(.gray300))
    )
    .overlay {
      RoundedRectangle(cornerRadius: folderItemType.cornerRadius)
        .stroke(Color.bkColor(.gray500), lineWidth: 1)
        .padding(1)
    }
    .onTapGesture { action() }
  }
}
