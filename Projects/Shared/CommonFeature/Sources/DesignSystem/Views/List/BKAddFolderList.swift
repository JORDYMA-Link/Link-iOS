//
//  BKAddFolderList.swift
//  CommonFeature
//
//  Created by kyuchul on 8/16/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

/// 콘텐츠 디테일에서는 [String], 폴더 수정 바텀시트에서는 [Folder]로 사용되기 때문에 구현
public protocol FolderItem: Equatable {
  var folderName: String { get }
}

extension String: FolderItem {
  public var folderName: String {
    return self
  }
}

public struct BKAddFolderList<Item: FolderItem>: View {
  private let folderItemType: FolderItemType
  private let folderList: [Item]
  private let selectedFolder: Item
  private let itemAction: (Item) -> Void
  private let addAction: () -> Void
  
  public init(
    folderItemType: FolderItemType = .addFolderBottomSheet,
    folderList: [Item],
    selectedFolder: Item,
    itemAction: @escaping (Item) -> Void,
    addAction: @escaping () -> Void
  ) {
    self.folderItemType = folderItemType
    self.folderList = folderList
    self.selectedFolder = selectedFolder
    self.itemAction = itemAction
    self.addAction = addAction
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      let type = folderItemType == .addFolderBottomSheet
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 10) {
          if !type {
            BKAddFolderItem(
              folderItemType: folderItemType,
              action: { addAction() }
            )
          }
          
          ForEach(folderList, id: \.folderName) { item in
            BKFolderItem(
              folderItemType: folderItemType,
              title: item.folderName,
              isSeleted: selectedFolder == item,
              action: { itemAction(item) }
            )
          }
          
          if type {
            BKAddFolderItem(
              folderItemType: folderItemType,
              action: { addAction() }
            )
          }
        }
        .padding(.horizontal, 16)
      }
      
      if selectedFolder.folderName == "미분류" {
        unclassifiedLabel
      }
    }
  }
  
  @ViewBuilder
  private var unclassifiedLabel: some View {
    BKText(
      text: "미분류된 콘텐츠는 홈 미분류 페이지에 노출되요",
      font: .regular,
      size: ._12,
      lineHeight: 18,
      color: .bkColor(.main300)
    )
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.top, 8)
    .padding(.leading, 16)
  }
}

