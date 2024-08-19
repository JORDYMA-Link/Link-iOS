//
//  BKChipView.swift
//  CommonFeature
//
//  Created by 김규철 on 5/5/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

public enum ChipType {
  /// 추가, 삭제 불가
  case `default`
  /// 삭제만 가능
  case delete
  /// 추가, 삭제 가능
  case addWithDelete
}

public struct BKChipView: View {
  @Binding var keywords: [String]
  private let chipType: ChipType
  private let deleteAction: ((String) -> Void)?
  private let addAction: (() -> Void)?
  
  public init(
    keywords: Binding<[String]>,
    chipType: ChipType,
    deleteAction: ((String) -> Void)? = nil,
    addAction: (() -> Void)? = nil
  ) {
    self._keywords = keywords
    self.chipType = chipType
    self.deleteAction = deleteAction
    self.addAction = addAction
  }
  
  public var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 4) {
        ForEach(keywords, id: \.self) { keyword in
          ChipItem(
            title: keyword,
            type: chipType,
            isAdd: false,
            deleteAction: deleteAction,
            addAction: addAction
          )
        }
        
        if chipType == .addWithDelete {
          ChipItem(
            title: "추가하기",
            type: chipType,
            isAdd: true,
            deleteAction: deleteAction,
            addAction: addAction
          )
        }
      }
    }
    .frame(minHeight: 26, maxHeight: 26)
  }
}

private struct ChipItem: View {
  private let title: String
  private let type: ChipType
  private var isAdd: Bool
  private let deleteAction: ((String) -> Void)?
  private let addAction: (() -> Void)?
  
  init(
    title: String,
    type: ChipType,
    isAdd: Bool,
    deleteAction: ((String) -> Void)?,
    addAction: (() -> Void)?
  ) {
    self.title = title
    self.type = type
    self.isAdd = isAdd
    self.deleteAction = deleteAction
    self.addAction = addAction
  }
  
  var body: some View {
    HStack(spacing: 2) {
      BKText(
        text: title,
        font: .semiBold,
        size: ._11,
        lineHeight: 16,
        color: .bkColor(.gray700)
      )
      .lineLimit(1)
      
      if type != .default {
        BKIcon(
          image: isAdd ? CommonFeature.Images.icoPlus : CommonFeature.Images.icoClose,
          color: .bkColor(.gray700),
          size: .init(width: 12, height: 12)
        )
        .onTapGesture {
          isAdd ? addAction?() : deleteAction?(title)
        }
      }
    }
    .padding(.vertical, 4)
    .padding(.horizontal, 8)
    .background(Capsule().fill(.white))
    .overlay {
      Capsule()
        .stroke(Color.bkColor(.gray500), lineWidth: 1)
        .padding(1)
    }
  }
}
