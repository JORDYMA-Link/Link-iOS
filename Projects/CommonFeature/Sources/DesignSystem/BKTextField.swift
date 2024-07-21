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
  
  var errorTitle: String {
    switch self {
    case .addFolder, .editFolderName:
      return "폴더 이름은 10글자 이내로 입력해주세요"
    case .addKeyword:
      return "키워드는 최대 3개까지 지정할 수 있습니다."
    case .addMemo:
      return "메모는 1000자까지 입력 가능해요."
    case .editLinkTitle:
      return "제목은 최소 2자, 최대 50자까지 입력 가능해요."
    case .editLinkContent:
      return "요약 내용은 최소 2자, 최대 200자까지 입력 가능해요."
    default:
      return ""
    }
  }
  
  var leadingTrailingWhitespaceErrorTitle: String {
    switch self {
    case .addFolder, .editFolderName:
      "폴더 이름 시작과 끝에는 공백을 입력할 수 없어요"
    default:
      ""
    }
  }
}

public struct BKTextField: View {
  @Binding var text: String
  @Binding var isHighlight: Bool
  private var textFieldType: BKTextFieldType
  private var textCount: Int
  private let height: CGFloat
  private let isMultiLine: Bool
  
  @FocusState private var textIsFocused: Bool
  @State private var validationError: ValidationError?
  
  private enum ValidationError {
    case textcount
    case haspifx
  }
  
  public init(
    text: Binding<String>,
    isHighlight: Binding<Bool>,
    textFieldType: BKTextFieldType,
    textCount: Int,
    isMultiLine: Bool,
    height: CGFloat = 36
  ) {
    _text = text
    _isHighlight = isHighlight
    self.textFieldType = textFieldType
    self.textCount = textCount
    self.isMultiLine = isMultiLine
    self.height = height
  }
  
  // 외부 FocusState 사용
  public init(
    text: Binding<String>,
    isHighlight: Binding<Bool>,
    textIsFocused: FocusState<Bool>,
    textFieldType: BKTextFieldType,
    textCount: Int,
    isMultiLine: Bool,
    height: CGFloat = 36
  ) {
    _text = text
    _isHighlight = isHighlight
    _textIsFocused = textIsFocused
    self.textFieldType = textFieldType
    self.textCount = textCount
    self.isMultiLine = isMultiLine
    self.height = height
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      makeTextField
        .frame(height: height - 16)
        .padding(.vertical, 8)
        .padding(.horizontal, 15)
        .background(Color.bkColor(.gray300))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(!isHighlight ? Color.bkColor(.gray500) : Color.bkColor(.red), lineWidth: 1)
        )
      
      HStack(spacing: 8) {
        makeValidLabel
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
    let textField = TextField(text: $text) {
      Text(textFieldType.placeholder)
        .font(.regular(size: ._14))
        .foregroundStyle(Color.bkColor(.gray800))
    }
      .tint(.bkColor(.gray900))
      .font(.regular(size: ._14))
      .focused($textIsFocused)
      .onSubmit {
        textIsFocused = false
      }
    
    if #available(iOS 17.0, *) {
      textField
        .onChange(of: text) { updateIsHighlight() }
    } else {
      textField
        .onChange(of: text, perform: { _ in updateIsHighlight()})
    }
  }
  
  @ViewBuilder
  private var multiLineTextView: some View {
    let textEditer = TextEditor(text: $text)
      .tint(.bkColor(.gray900))
      .font(.regular(size: ._14))
      .scrollContentBackground(.hidden)
      .focused($textIsFocused)
      .onSubmit {
        textIsFocused = false
      }
    
    if #available(iOS 17.0, *) {
      textEditer
        .onChange(of: text) { updateIsHighlight() }
    } else {
      textEditer
        .onChange(of: text, perform: { _ in updateIsHighlight()})
    }
  }
  
  /// 멀티라인 + 플레이스 홀더
  @ViewBuilder
  private var multiLineTextField: some View {
    let textField = TextField("", text: $text, axis: .vertical)
      .tint(.bkColor(.gray900))
      .font(.regular(size: ._14))
      .focused($textIsFocused)
      .onSubmit {
        textIsFocused = false
      }
    
    if #available(iOS 17.0, *) {
      textField
        .onChange(of: text) { updateIsHighlight() }
    } else {
      textField
        .onChange(of: text, perform: { _ in updateIsHighlight()})
    }
  }
  
  @ViewBuilder
  private var makeValidLabel: some View {
    let errorMessage: String = {
      switch textFieldType {
      case .addFolder, .editFolderName:
        return validationError == .haspifx ? textFieldType.leadingTrailingWhitespaceErrorTitle : textFieldType.errorTitle
      default:
        return textFieldType.errorTitle
      }
    }()
    
    Text(errorMessage)
      .font(.regular(size: ._12))
      .foregroundStyle(Color.bkColor(.red))
      .padding(.top, 8)
      .frame(maxWidth: .infinity, alignment: .leading)
      .opacity(!isHighlight ? 0 : 1)
  }
}

// MARK: - 정규식 체크

extension BKTextField {
  private func updateIsHighlight() {
    switch textFieldType {
    case .addFolder, .editFolderName:
      isHighlight = !isValidFolderName(text: text)
      
    case .addMemo:
      isHighlight = !isValidMemo(text: text)
      
    case .editLinkTitle:
      isHighlight = !isValidLinkTitle(text: text)
      
    case .editLinkContent:
      isHighlight = !isValidLinkContent(text: text)
      
    default:
      break
    }
  }
}

// MARK: - 정규식

extension BKTextField {
  /// 폴더 이름 체크 정규식
  private func isValidFolderName(text: String) -> Bool {
    let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]{1,10}$"
    
    if text.isEmpty {
      self.validationError = .textcount
      return false
    }
    
    if text.hasPrefix(" ") || text.hasSuffix(" ") {
      self.validationError = .haspifx
      return false
    }
    
    if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
      let range = NSRange(location: 0, length: text.utf16.count)
      
      if regex.firstMatch(in: text, options: [], range: range) != nil {
        if text.count <= 10 {
          return true
        } else {
          self.validationError = .textcount
          return false
        }
      }
    }
    
    return false
  }
  
  /// 콘텐츠 상세 > 메모 수정 정규식
  private func isValidMemo(text: String) -> Bool {
    return text.count <= 1000
  }
  
  /// 콘텐츠 상세 > 내용 수정 > 제목 정규식
  private func isValidLinkTitle(text: String) -> Bool {
    return 2 <= text.count && text.count <= 50
  }
  
  /// 콘텐츠 상세 > 내용 수정 > 요약 내용 정규식
  private func isValidLinkContent(text: String) -> Bool {
    return 2 <= text.count && text.count <= 200
  }
}
