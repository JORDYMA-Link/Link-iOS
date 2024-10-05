//
//  BKSaveContentMenu.swift
//  Blink
//
//  Created by 김규철 on 2024/04/07.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

// MARK: - BKSaveContentMenuType

enum BKSaveContentMenuType: Int, CaseIterable {
  case link
  // 1.0.0 출시 이후 업데이트 버전에 추가 예정
  //     case text
  
  var image: Image {
    switch self {
    case .link:
      return CommonFeature.Images.icoLink
      //        case .text:
      //            return CommonFeatureAsset.Images.icoRoundEdit.swiftUIImage
    }
  }
  
  var title: String {
    switch self {
    case .link:
      return "링크 저장"
      //        case .text:
      //            return "텍스트 저장"
    }
  }
}

// MARK: - BKSaveContentMenu

struct BKSaveContentMenu: View {
  private let action: () -> Void
  
  init(action: @escaping () -> Void) {
    self.action = action
  }
  
  var body: some View {
    HStack(alignment: .center, spacing: 24) {
      ForEach(BKSaveContentMenuType.allCases, id: \.self) { type in
        MenuItem(type: type)
          .onTapGesture { action() }
      }
    }
    .transition(.scale)
  }
}

private struct MenuItem: View {
  private let type: BKSaveContentMenuType
  
  init(type: BKSaveContentMenuType) {
    self.type = type
  }
  
  var body: some View {
    VStack(alignment: .center, spacing: 6) {
      ZStack {
        Circle()
          .foregroundColor(Color.bkColor(.white))
          .frame(width: 56, height: 56)
        
        BKIcon(
          image: type.image,
          color: .bkColor(.main300),
          size: .init(width: 28, height: 28)
        )
      }
      
      Text(type.title)
        .foregroundColor(Color.bkColor(.white))
        .font(.semiBold(size: ._15))
    }
  }
}
