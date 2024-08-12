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
  public let title: String
  public let imageType: ImageType?
  public let description: String
  public let buttonType: ButtonType
  public let leftButtonAction: (() async -> Void)?
  public let rightButtonAction: () async -> Void
    
  public init(
    title: String,
    imageType: ImageType? = nil,
    description: String,
    buttonType: ButtonType,
    leftButtonAction: (() async -> Void)? = nil,
    rightButtonAction: @escaping () async -> Void
  ) {
    self.title = title
    self.imageType = imageType
    self.description = description
    self.buttonType = buttonType
    self.leftButtonAction = leftButtonAction
    self.rightButtonAction = rightButtonAction
  }
}

public extension BKAlertProperty {
  enum ImageType {
    case folder
    case image
    case link
    case search
    case star
    
    var image: Image {
      switch self {
      case .folder:
        return CommonFeature.Images.icoEmptyFolder
      case .image:
        return CommonFeature.Images.icoEmptyImg
      case .link:
        return CommonFeature.Images.icoEmptyLink
      case .search:
        return CommonFeature.Images.icoEmptySearch
      case .star:
        return CommonFeature.Images.icoEmptyStar
      }
    }
  }
  
  enum ButtonType {
    case singleButton(String = "확인")
    case doubleButton(left: String, right: String)
  }
}
