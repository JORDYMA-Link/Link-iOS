//
//  BKAddFolderItem.swift
//  CommonFeature
//
//  Created by kyuchul on 7/10/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct BKAddFolderItem: View {
  private let action: () -> Void
  private let isBottomSheet: Bool
  
  public init(
    action: @escaping () -> Void,
    isBottomSheet: Bool = true
  ) {
    self.action = action
    self.isBottomSheet = isBottomSheet
  }
  
  public var body: some View {
    BKIcon(
      image: CommonFeature.Images.icoPlus,
      color: .bkColor(.gray600),
      size: CGSize(width: 20, height: 20)
    )
    .padding(.vertical, isBottomSheet ? 13 : 9)
    .padding(.horizontal, isBottomSheet ? 15 : 13)
    .background(
      RoundedRectangle(cornerRadius: isBottomSheet ? 10 : 8)
        .fill(Color.bkColor(.gray300))
    )
    .overlay {
      RoundedRectangle(cornerRadius: isBottomSheet ? 10 : 8)
        .stroke(Color.bkColor(.gray500), lineWidth: 1)
    }
    .onTapGesture { action() }
  }
}
