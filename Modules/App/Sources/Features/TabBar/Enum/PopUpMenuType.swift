//
//  PopUpMenuType.swift
//  Blink
//
//  Created by 김규철 on 2024/04/08.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

enum PopUpMenuType: Int, CaseIterable {
    case link
    case text
    
    var image: Image {
        switch self {
        case .link:
            return CommonFeatureAsset.Images.icoLink.swiftUIImage
        case .text:
            return CommonFeatureAsset.Images.icoRoundEdit.swiftUIImage
        }
    }
    
    var title: String {
        switch self {
        case .link:
            return "링크 저장"
        case .text:
            return "텍스트 저장"
        }
    }
}
