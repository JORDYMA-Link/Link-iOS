//
//  BKConfirmButton.swift
//  CommonFeature
//
//  Created by kyuchul on 6/18/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct BKConfirmButton: View {
  public var title: String
  public var isDisabled: Bool
  public var confirmAction: () -> Void
  public var isCornerRadius = false
  
  public init(title: String, isDisabled: Bool = false, isCornerRadius: Bool = true, confirmAction: @escaping () -> Void) {
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
          .fill(Color.bkColor(isDisabled ? .gray500 : .main300))
          .frame(maxWidth: .infinity)
        
        Text(title)
          .font(.semiBold(size: ._16))
          .foregroundStyle(Color.bkColor(isDisabled ? .gray600 : .white))
          .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
      }
      .frame(height: 52)
    }
    .disabled(isDisabled)
  }
}
