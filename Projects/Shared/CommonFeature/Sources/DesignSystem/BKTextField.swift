//
//  BKTextField.swift
//  CommonFeature
//
//  Created by kyuchul on 6/9/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

public enum BKTextFieldType {
  case addFolder
  case editFolderName
  case addKeyword
  case searchKeyword
  case addMemo
  case editLinkTitle
  case editLinkContent
  
  var placeholder: String {
    switch self {
    case .addFolder:
      return "추가할 폴더를 입력해주세요"
    case .addKeyword:
      return "추가할 키워드를 입력해주세요"
    case .searchKeyword:
      return "검색어를 입력해 주세요"
    default:
      return ""
    }
  }
}

public struct BKTextField: View {
  @Binding var text: String
  private var isValidation: Bool
  private var textFieldType: BKTextFieldType
  private var textCount: Int
  private let height: CGFloat
  private let isMultiLine: Bool
  private let isClearButton: Bool
  private let errorMessage: String
  
  @FocusState private var textIsFocused: Bool
  
  public init(
    text: Binding<String>,
    isValidation: Bool,
    textFieldType: BKTextFieldType,
    textCount: Int,
    isMultiLine: Bool,
    isClearButton: Bool = false,
    errorMessage: String,
    height: CGFloat = 36
  ) {
    self._text = text
    self.isValidation = isValidation
    self.textFieldType = textFieldType
    self.textCount = textCount
    self.isMultiLine = isMultiLine
    self.isClearButton = isClearButton
    self.errorMessage = errorMessage
    self.height = height
  }
  
  // 외부 FocusState 사용
  public init(
    text: Binding<String>,
    isValidation: Bool,
    textIsFocused: FocusState<Bool>,
    textFieldType: BKTextFieldType,
    textCount: Int,
    isMultiLine: Bool,
    isClearButton: Bool = false,
    errorMessage: String,
    height: CGFloat = 36
  ) {
    self._text = text
    self.isValidation = isValidation
    _textIsFocused = textIsFocused
    self.textFieldType = textFieldType
    self.textCount = textCount
    self.isMultiLine = isMultiLine
    self.isClearButton = isClearButton
    self.errorMessage = errorMessage
    self.height = height
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      HStack(spacing: 6) {
        makeTextField
        
        if isClearButton {
          makeClearButton
        }
      }
      .frame(height: height - 16)
      .padding(.vertical, 8)
      .padding(.horizontal, 15)
      .background(Color.bkColor(.gray300))
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(isValidation ? Color.bkColor(.gray500) : Color.bkColor(.red), lineWidth: 1)
      )
      
      HStack(spacing: 8) {
        makeValidLabel(errorTitle: errorMessage)
        
        BKText(
          text: "\(text.count)/\(textCount)",
          font: .regular,
          size: ._12,
          lineHeight: 18,
          color: .bkColor(.gray600)
        )
      }
    }
  }
}

extension BKTextField {
  @ViewBuilder
  private var makeTextField: some View {
    if isMultiLine {
      multiLineTextView
    } else {
      singleTextField
    }
  }
  
  @ViewBuilder
  private var singleTextField: some View {
    TextField(text: $text) {
      Text(textFieldType.placeholder)
        .font(.regular(size: ._14))
        .foregroundStyle(Color.bkColor(.gray800))
    }
    .tint(.bkColor(.gray900))
    .font(.regular(size: ._14))
    .focused($textIsFocused)
  }
  
  @ViewBuilder
  private var multiLineTextView: some View {
    TextEditor(text: $text)
      .tint(.bkColor(.gray900))
      .font(.regular(size: ._14))
      .scrollContentBackground(.hidden)
      .focused($textIsFocused)
  }
  
  /// 멀티라인 + 플레이스 홀더
  @ViewBuilder
  private var multiLineTextField: some View {
    TextField("", text: $text, axis: .vertical)
      .tint(.bkColor(.gray900))
      .font(.regular(size: ._14))
      .focused($textIsFocused)
  }
  
  @ViewBuilder
  private func makeValidLabel(errorTitle: String) -> some View {
    Text(errorTitle)
      .font(.regular(size: ._12))
      .foregroundStyle(Color.bkColor(.red))
      .padding(.top, 8)
      .frame(maxWidth: .infinity, alignment: .leading)
      .opacity(isValidation ? 0 : 1)
  }
  
  @ViewBuilder
  private var makeClearButton: some View {
    Button {
      text = ""
    } label: {
      CommonFeature.Images.icoCircleCloseGray
        .resizable()
        .scaledToFit()
        .frame(width: 18, height: 18)
    }
    .opacity(!text.isEmpty ? 1 : 0)
  }
}
