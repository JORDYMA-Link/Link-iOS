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

public enum BKChipDesignType {
  case main
  case gray
  
  var backgroundColor: Color {
    switch self {
    case .main:
      return .bkColor(.main50)
    case .gray:
      return .white
    }
  }
  
  var fontColor: Color {
    switch self {
    case .main:
      return .bkColor(.main300)
    case .gray:
      return .bkColor(.gray700)
    }
  }
  
  var iconColor: Color {
    switch self {
    case .main:
      return .bkColor(.main300)
    case .gray:
      return .bkColor(.gray700)
    }
  }
  
  var strokeColor: Color {
    switch self {
    case .main:
      return .bkColor(.main50)
    case .gray:
      return .bkColor(.gray500)
    }
  }
}

public struct BKChipView: View {
  @Binding var keywords: [String]
  private let highlighted: String?
  private let chipType: ChipType
  private let designType: BKChipDesignType
  private let deleteAction: ((String) -> Void)?
  private let addAction: (() -> Void)?
  
  public init(
    keywords: Binding<[String]>,
    highlighted: String? = nil,
    chipType: ChipType,
    designType: BKChipDesignType = .gray,
    deleteAction: ((String) -> Void)? = nil,
    addAction: (() -> Void)? = nil
  ) {
    self._keywords = keywords
    self.highlighted = highlighted
    self.chipType = chipType
    self.designType = designType
    self.deleteAction = deleteAction
    self.addAction = addAction
  }
  
  public var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      LazyHStack(spacing: 4) {
        ForEach(keywords, id: \.self) { keyword in
          ChipItem(
            title: keyword,
            highlighted: highlighted,
            type: chipType,
            designType: designType,
            isAdd: false,
            deleteAction: deleteAction,
            addAction: addAction
          )
        }
        
        if chipType == .addWithDelete {
          ChipItem(
            title: "추가하기",
            type: chipType,
            designType: designType,
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
  private let highlighted: String?
  private let type: ChipType
  private let designType: BKChipDesignType
  private var isAdd: Bool
  private let deleteAction: ((String) -> Void)?
  private let addAction: (() -> Void)?
  
  init(
    title: String,
    highlighted: String? = nil,
    type: ChipType,
    designType: BKChipDesignType,
    isAdd: Bool,
    deleteAction: ((String) -> Void)?,
    addAction: (() -> Void)?
  ) {
    self.title = title
    self.highlighted = highlighted
    self.type = type
    self.designType = designType
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
        color: highlighted?.highlighted() == title.highlighted() ? .bkColor(.main300) : designType.fontColor
      )
      .lineLimit(1)
      
      if type != .default {
        BKIcon(
          image: isAdd ? CommonFeature.Images.icoPlus : CommonFeature.Images.icoClose,
          color: designType.iconColor,
          size: .init(width: 12, height: 12)
        )
      }
    }
    .padding(.vertical, 4)
    .padding(.horizontal, 8)
    .background(Capsule().fill(designType.backgroundColor))
    .overlay {
      Capsule()
        .stroke(designType.strokeColor, lineWidth: 1)
        .padding(1)
    }
    .hapticTapGesture {
      isAdd ? addAction?() : deleteAction?(title)
    }
  }
}

private extension String {
  func highlighted() -> String {
    return self.lowercased().replacingOccurrences(of: " ", with: "")
  }
}
