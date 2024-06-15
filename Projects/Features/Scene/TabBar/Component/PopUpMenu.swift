//
//  PopUpMenu.swift
//  Blink
//
//  Created by 김규철 on 2024/04/07.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

// MARK: - PopUpMenuType

enum PopUpMenuType: Int, CaseIterable {
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

// MARK: - PopUpMenu

struct PopUpMenu: View {
    var saveLinkAction: (() -> Void)
    
    init(saveLinkAction: @escaping () -> Void) {
        self.saveLinkAction = saveLinkAction
    }
    
    var body: some View {
        HStack(spacing: 24) {
            Spacer()
            Spacer()
            Spacer()
            
            ForEach(PopUpMenuType.allCases, id: \.self) { item in
                MenuItem(menuType: item)
                    .onTapGesture {
                        saveLinkAction()
                    }
            }
      
            Spacer()
            Spacer()
            Spacer()
        }
        .transition(.scale)
    }
}

struct MenuItem: View {
    let menuType: PopUpMenuType
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            ZStack {
                Circle()
                    .foregroundColor(Color.bkColor(.white))
                    .frame(width: 56, height: 56)
                
                menuType.image
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.bkColor(.main300))
            }
            
            Text(menuType.title)
                .foregroundColor(Color.bkColor(.white))
                .font(.semiBold(size: ._15))
        }
    }
}
