//
//  BKAlertProperty.swift
//  CommonFeature
//
//  Created by kyuchul on 8/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

public struct BKAlertProperty: Identifiable {
  public let id: UUID = .init()
  public let isLoadingType: Bool
  public let title: String
  public let imageType: ImageType?
  public let description: String
  public let bottomImageType: BottomImageType?
  public let buttonType: ButtonType
  public let leftButtonAction: (() async -> Void)?
  public let rightButtonAction: () async -> Void
  public let isRightButtonDismiss: Bool
    
  public init(
    isLoadingType: Bool = false,
    title: String,
    imageType: ImageType? = nil,
    description: String,
    bottomImageType: BottomImageType? = nil,
    buttonType: ButtonType,
    leftButtonAction: (() async -> Void)? = nil,
    rightButtonAction: @escaping () async -> Void,
    isRightButtonDismiss: Bool = true
  ) {
    self.isLoadingType = isLoadingType
    self.title = title
    self.imageType = imageType
    self.description = description
    self.bottomImageType = bottomImageType
    self.buttonType = buttonType
    self.leftButtonAction = leftButtonAction
    self.rightButtonAction = rightButtonAction
    self.isRightButtonDismiss = isRightButtonDismiss
  }
}

public extension BKAlertProperty {
  enum ImageType {
    case folder
    case image
    case link
    case search
    case star
  }
  
  enum BottomImageType {
    case promotion(count: Int)
  }
  
  enum ButtonType {
    case singleButton(String = "확인", Bool = false)
    case doubleButton(left: String, right: String)
  }
}
