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
  private var height: CGFloat
  private var textCount: Int
  
  @FocusState private var textIsFocused: Bool
  @State private var validationError: ValidationError?
  private enum Constants: CGFloat {
    case vertical = 26
  }
  
  private enum ValidationError {
    case textcount
    case haspifx
  }
  
  public init(
    text: Binding<String>,
    isHighlight: Binding<Bool>,
    textFieldType: BKTextFieldType,
    height: CGFloat,
    textCount: Int
  ) {
    _text = text
    _isHighlight = isHighlight
    self.textFieldType = textFieldType
    self.height = height
    self.textCount = textCount
  }
  
  // 외부 FocusState 사용
  public init(
    text: Binding<String>,
    isHighlight: Binding<Bool>,
    textIsFocused: FocusState<Bool>,
    textFieldType: BKTextFieldType,
    height: CGFloat,
    textCount: Int
  ) {
    _text = text
    _isHighlight = isHighlight
    _textIsFocused = textIsFocused
    self.textFieldType = textFieldType
    self.height = height
    self.textCount = textCount
  }
  
  public var body: some View {
    VStack(spacing: 0) {
      makeTextField()
        .frame(height: height - Constants.vertical.rawValue)
        .padding(.vertical, 13)
        .padding(.horizontal, 16)
        .background(Color.bkColor(.gray300))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
          RoundedRectangle(cornerRadius: 10)
            .stroke(!isHighlight ? Color.bkColor(.gray500) : Color.bkColor(.red), lineWidth: 1)
        )
      
      HStack(spacing: 8) {
        makeValidationLabel()
        makeTextCountLabel(textCount: textCount)
      }
    }
  }
}

extension BKTextField {
  @ViewBuilder
  private func makeTextField() -> some View {
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
    
    // textField 정규식 체크가 필요할 시
    if #available(iOS 17.0, *) {
      textField
        .onChange(of: text) { updateIsHighlight() }
    } else {
      textField
        .onChange(of: text, perform: { _ in updateIsHighlight()})
    }
  }
  
  @ViewBuilder
  private func makeValidationLabel() -> some View {
    let errorMessage: String = {
      if textFieldType == .addFolder || textFieldType == .editFolderName  {
        return validationError == .haspifx ? textFieldType.leadingTrailingWhitespaceErrorTitle : textFieldType.errorTitle
      } else {
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
  
  @ViewBuilder
  private func makeTextCountLabel(textCount: Int) -> some View {
    let fontHeight = UIFont.regular(size: ._12).lineHeight
    
    Text("\(text.count)/\(textCount)")
      .font(.regular(size: ._12))
      .padding(.vertical, (18 - fontHeight) / 2)
      .foregroundStyle(Color.bkColor(.gray600))
  }
}

extension BKTextField {
  private func updateIsHighlight() {
    switch textFieldType {
    case .addFolder, .editFolderName:
      if !isValidationFolderName(text: text) {
        isHighlight = true
      } else {
        isHighlight = false
      }
      
    default:
      break
    }
  }
  
  // 폴더 이름 체크 정규식
  private func isValidationFolderName(text: String) -> Bool {
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
}
