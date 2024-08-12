//
//  BKAlert.swift
//  CommonFeature
//
//  Created by kyuchul on 8/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Lottie

struct BKAlert: View {
  private let isLoadingType: Bool
  private let title: String
  private let imageType: BKAlertProperty.ImageType?
  private let description: String
  private let buttonType: BKAlertProperty.ButtonType
  private let leftAction: (() async -> Void)
  private let rightAction: (() async -> Void)
  
  init(
    isLoadingType: Bool = false,
    title: String,
    imageType: BKAlertProperty.ImageType? = nil,
    description: String,
    buttonType: BKAlertProperty.ButtonType,
    leftAction: @escaping () async -> Void,
    rightAction: @escaping () async -> Void
  ) {
    self.isLoadingType = isLoadingType
    self.title = title
    self.imageType = imageType
    self.description = description
    self.buttonType = buttonType
    self.leftAction = leftAction
    self.rightAction = rightAction
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 8) {
      if isLoadingType {
        LottieView(
          animation: .named(
            "lodingAnimation",
            bundle: CommonFeatureResources.bundle
          )
        )
        .playing(loopMode: .loop)
        .frame(width: 90, height: 59, alignment: .center)
      }
      
      BKText(
        text: title,
        font: .semiBold,
        size: ._16,
        lineHeight: 24,
        color: .bkColor(.gray900)
      )
      .multilineTextAlignment(.center)
      
      if let imageType = imageType {
        imageType.image
          .padding(12)
      }
      
      BKText(
        text: description,
        font: .regular,
        size: ._14,
        lineHeight: 20,
        color: .bkColor(.gray700)
      )
      .multilineTextAlignment(.center)
      
      BKAlertButton(
        buttonType: buttonType,
        leftAction: leftAction,
        rightAction: rightAction
      )
      .padding(.top, 8)
    }
    .padding(EdgeInsets(top: 28, leading: 20, bottom: 28, trailing: 20))
    .background(Color.white)
    .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}

private struct BKAlertButton: View {
  private let buttonType: BKAlertProperty.ButtonType
  private let leftAction: () async -> Void
  private let rightAction: () async -> Void
  
  init(
    buttonType: BKAlertProperty.ButtonType,
    leftAction: @escaping () async -> Void,
    rightAction: @escaping () async -> Void
  ) {
    self.buttonType = buttonType
    self.leftAction = leftAction
    self.rightAction = rightAction
  }
  
  var body: some View {
    switch buttonType {
    case let .singleButton(title):
      singleButton(title: title, isCancel: false, action: rightAction)
    case let .doubleButton(left, right):
      doubleButton(leftTitle: left, rightTtitle: right, leftAction: leftAction, rightAction: rightAction)
    }
  }
  
  @ViewBuilder
  private func singleButton(
    title: String,
    isCancel: Bool,
    action: @escaping () async -> Void
  ) -> some View {
    Button(action: {
      Task { @MainActor in
        await action()
      }
    }) {
      BKText(
        text: title,
        font: .semiBold,
        size: ._14,
        lineHeight: 20,
        color: isCancel ? Color.bkColor(.gray700) : .white
      )
      .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .center)
      .background(isCancel ? .white : Color.bkColor(.gray900))
      .border(Color.bkColor(.gray500), width: isCancel ? 1 : 0)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color.bkColor(.gray500), lineWidth: isCancel ? 1 : 0)
      )
    }
    .buttonStyle(.plain)
  }
  
  
  @ViewBuilder
  private func doubleButton(
    leftTitle: String,
    rightTtitle: String,
    leftAction: @escaping () async -> Void,
    rightAction: @escaping () async -> Void
  ) -> some View {
    HStack(spacing: 7) {
      singleButton(title: leftTitle, isCancel: true, action: { await leftAction() })
      singleButton(title: rightTtitle, isCancel: false, action: { await rightAction() })
    }
  }
}
