//
//  BKCategoryButton.swift
//  CommonFeature
//
//  Created by kyuchul on 8/16/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public enum CategoryType: String, CaseIterable {
  case all = "ALL"
  case bookmarked = "BOOKMARKED"
  case unclassified = "UNCLASSIFIED"
  
  public var title: String {
    switch self {
    case .all:
      return "전체"
    case .bookmarked:
      return "북마크"
    case .unclassified:
      return "미분류"
    }
  }
}

public struct BKCategoryButton: View {
  private let title: String
  private let isSelected: Bool
  private let action: () -> Void
  
  public init(
    title: String,
    isSelected: Bool,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.isSelected = isSelected
    self.action = action
  }
  
  public var body: some View {
    BKText(
      text: title,
      font: isSelected ? .semiBold : .regular,
      size: ._14, lineHeight: 20,
      color: .bkColor(isSelected ? .white : .gray900)
    )
    .padding(.vertical, 10)
    .padding(.horizontal, 14)
    .background(
      RoundedRectangle(cornerRadius: 100)
        .fill(isSelected ? .black : .white)
    )
    .overlay {
      RoundedRectangle(cornerRadius: 100)
        .stroke(Color.bkColor(.gray500), lineWidth: isSelected ? 0 : 1)
    }
    .hapticTapGesture(.selection) { action() }
  }
}
