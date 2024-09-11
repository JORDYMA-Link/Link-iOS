//
//  BKRoundedButton.swift
//  CommonFeature
//
//  Created by kyuchul on 6/18/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public enum BKRoundedButtonType {
  case main
  case gray
  case black
  
  var tintColor: BKColor {
    switch self {
    case .main, .black:
      return .white
    case .gray:
      return .gray900
    }
  }
  
  var backgroundColor: BKColor {
    switch self {
    case .main:
      return .main300
    case .gray:
      return .gray300
    case .black:
      return .gray900
    }
  }
  
  var stroke: CGFloat {
    switch self {
    case .main, .black:
      return 0
    case .gray:
      return 1
    }
  }
}

public struct BKRoundedButton: View {
  private let buttonType: BKRoundedButtonType
  private let title: String
  private let isDisabled: Bool
  private let confirmAction: () -> Void
  private var isCornerRadius = false
  
  public init(
    buttonType: BKRoundedButtonType = .main,
    title: String,
    isDisabled: Bool = false,
    isCornerRadius: Bool = true,
    confirmAction: @escaping () -> Void
  ) {
    self.buttonType = buttonType
    self.title = title
    self.isDisabled = isDisabled
    self.confirmAction = confirmAction
    self.isCornerRadius = isCornerRadius
  }
  
  public var body: some View {
    Button {
      confirmAction()
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: isCornerRadius ? 10 : 0, style: .continuous)
          .fill(Color.bkColor(isDisabled ? .gray500 : buttonType.backgroundColor))
          .frame(maxWidth: .infinity)
          .overlay {
            RoundedRectangle(cornerRadius: isCornerRadius ? 10 : 0, style: .continuous)
              .stroke(Color.bkColor(.gray500), lineWidth: buttonType.stroke)
          }
        
        Text(title)
          .font(.semiBold(size: ._16))
          .foregroundStyle(Color.bkColor(isDisabled ? .gray600 : buttonType.tintColor))
          .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
      }
      .frame(height: 52)
    }
    .disabled(isDisabled)
  }
}
