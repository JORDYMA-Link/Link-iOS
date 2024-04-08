//
//  TabViewType.swift
//  Blink
//
//  Created by 김규철 on 2024/04/07.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

enum TabViewType: Int, CaseIterable {
    case home
    case folder
    
    var image: Image {
        switch self {
        case .home:
            return CommonFeatureAsset.Images.icoHome.swiftUIImage
        case .folder:
            return CommonFeatureAsset.Images.icoFolder.swiftUIImage
        }
    }
    
    var selectedImage: Image {
        switch self {
        case .home:
            return CommonFeatureAsset.Images.icoHomeClcik.swiftUIImage
        case .folder:
            return CommonFeatureAsset.Images.icoFolderClick.swiftUIImage
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .home:
            HomeView()
        case .folder:
            Text("Folder")
        }
    }
}
