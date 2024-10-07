//
//  BKNavigationView.swift
//  CommonFeature
//
//  Created by 김규철 on 5/5/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

// MARK: - makeBKNavigationView

/// makeBKNavigationView는 toolbar를 사용하지 않고 커스텀해야할 때 사용하면 될 거 같습니다.
/// Ex: BottomSheet의 NavigationBar -> toolbar는 padding과 height 커스텀 X

@ViewBuilder
public func makeBKNavigationView(leadingType: LeadingItemTypes, trailingType: TrailingItemTypes, tintColor: Color = Color.bkColor(.black), containerColor: Color = Color.bkColor(.white)) -> some View {
    HStack {
        LeadingItem(type: leadingType)
        
        Spacer()
        
        TrailingItem(type: trailingType, tintColor: tintColor)
    }
    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
    .background(containerColor)
}

// MARK: - makeCustomBKNavigationView

@ViewBuilder
public func makeCustomBKNavigationView<R>(type: LeadingItemTypes, containerColor: Color = Color.bkColor(.white), rightView: @escaping (() -> R)) -> some View where R: View {
    HStack {
        LeadingItem(type: type)
        
        Spacer()
        
        rightView()
    }
    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
    .background(containerColor)
}
