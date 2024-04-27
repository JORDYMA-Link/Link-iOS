//
//  BKNavigationView.swift
//  Blink
//
//  Created by kyuchul on 4/26/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

// MARK: - makeBKNavigationView

@ViewBuilder
func makeBKNavigationView(leadingType: LeadingItemTypes, trailingType: TrailingItemTypes, tintColor: Color = Color.bkColor(.black), containerColor: Color = Color.bkColor(.white)) -> some View {
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
func makeCustomBKNavigationView<R>(type: LeadingItemTypes, containerColor: Color = Color.bkColor(.white), rightView: @escaping (() -> R)) -> some View where R: View {
    HStack {
        LeadingItem(type: type)
        
        Spacer()
        
        rightView()
    }
    .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
    .background(containerColor)
}
