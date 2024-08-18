//
//  BKChipView.swift
//  CommonFeature
//
//  Created by 김규철 on 5/5/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

public enum ChipType {
  case `default`
  case edit
}

public struct BKChipView: View {
  @Binding var keywords: [String]
  private let chipType: ChipType
  
  public init(
    keywords: Binding<[String]>,
    chipType: ChipType
  ) {
    self._keywords = keywords
    self.chipType = chipType
  }
  
  public var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 4) {
        ForEach(keywords, id: \.self) { keyword in
          ChipItem(title: keyword, type: chipType)
        }
        
        if chipType == .edit {
          ChipItem(title: "추가하기", type: chipType, isAdd: true)
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
  
  init(
    title: String,
    type: ChipType,
    isAdd: Bool = false
  ) {
    self.title = title
    self.type = type
    self.isAdd = isAdd
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
      
      if type == .edit {
        BKIcon(
          image: isAdd ? CommonFeature.Images.icoPlus : CommonFeature.Images.icoClose,
          color: .bkColor(.gray700),
          size: .init(width: 12, height: 12)
        )
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
