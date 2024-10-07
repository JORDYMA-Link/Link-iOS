//
//  BKMenuBottomSheet.swift
//  CommonFeature
//
//  Created by kyuchul on 8/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct BKMenuBottomSheet: View {
  private let menuItems: [MenuItem]
  private let action: ((BKMenuBottomSheet.Delegate) -> Void)?
  
  public init(
    menuItems: [MenuItem],
    action: ((BKMenuBottomSheet.Delegate) -> Void)?
  ) {
    self.menuItems = menuItems
    self.action = action
  }
  
  public var body: some View {
    VStack(alignment: .leading, spacing: 8) {
      ForEach(menuItems, id: \.hashValue) { item in
        menuItem(item)
      }
    }
    .padding(.horizontal, 16)
  }
  
  @ViewBuilder
  private func menuItem(_ item: BKMenuBottomSheet.MenuItem) -> some View {
    Text(item.title)
      .font(.regular(size: ._16))
      .foregroundStyle(Color.bkColor(item.isWarning ? .red : .gray900))
      .padding(.vertical, 8)
      .frame(maxWidth: .infinity, alignment: .leading)
      .contentShape(Rectangle())
      .onTapGesture { listCellTapped(item) }
  }
  
  private func listCellTapped(_ item: BKMenuBottomSheet.MenuItem) {
    switch item {
    case .editLink:
      action?(.editLinkItemTapped)
      return
    case .editFolder:
      action?(.editFolderItemTapped)
      return
    case .editFolderName:
      action?(.editFolderNameItemTapped)
      return
    case .deleteLink:
      action?(.deleteLinkItemTapped)
      return
    case .deleteFolder:
      action?(.deleteFolderItemTapped)
      return
    }
  }
}

public extension BKMenuBottomSheet {
  enum MenuItem: CaseIterable {
    case editLink
    case editFolder
    case editFolderName
    case deleteLink
    case deleteFolder
    
    var title: String {
      switch self {
      case .editLink:
        return "수정하기"
      case .editFolder:
        return "폴더 변경하기"
      case .editFolderName:
        return "폴더 이름 수정하기"
      case .deleteLink:
        return "삭제하기"
      case .deleteFolder:
        return "폴더 삭제하기"
      }
    }
    
    var isWarning: Bool {
      switch self {
      case .deleteLink, .deleteFolder:
        return true
      default:
        return false
      }
    }
  }
  
  enum Delegate {
    case editLinkItemTapped
    case editFolderItemTapped
    case editFolderNameItemTapped
    case deleteLinkItemTapped
    case deleteFolderItemTapped
  }
}
