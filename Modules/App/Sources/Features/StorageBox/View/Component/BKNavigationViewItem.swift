//
//  BKNavigationViewItem.swift
//  Blink
//
//  Created by kyuchul on 4/26/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

// MARK: - LeadingItemTypes

enum LeadingItemTypes: Equatable {
    case home
    case tab(String)
    case pop(String)
}

// MARK: - LeadingItem

struct LeadingItem: View {
    var type: LeadingItemTypes
    
    var body: some View {
        switch type {
        case .home:
            CommonFeatureAsset.Images.homeLogo.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 67, height: 32, alignment: .leading)
                .padding(.leading, 16)
            
        case let .tab(text):
            makeLeadingTextItem(title: text, font: .semiBold(size: ._18), textColor: .bkColor(.gray600))
                .padding(.leading, 16)
            
        case let .pop(text):
            makeLeadingTextItem(title: text, font: .semiBold(size: ._16), textColor: .bkColor(.black))
                .padding(.leading, 20)
        }
    }
    
    @ViewBuilder
    private func makeLeadingTextItem(title: String, font: Font, textColor: Color) -> some View {
        Text(title)
            .font(font)
            .foregroundStyle(textColor)
    }
}

// MARK: - TrailingItemTypes

enum TrailingItemTypes {
    case twoIcon(leftAction: () -> Void, rightAction: () -> Void, leftIcon: Image, rightIcon: Image)
    case oneIcon(action: () -> Void, icon: Image)
    case pop
    case none
}

// MARK: - TrailingItem

struct TrailingItem: View {
    var type: TrailingItemTypes
    var tintColor: Color
    
    var body: some View {
        switch type {
        case let .twoIcon(leftAction, rightAction, leftIcon, rightIcon):
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 18) {
                makeIconItem(action: leftAction, icon: leftIcon)
                
                makeIconItem(action: rightAction, icon: rightIcon)
            }
            .padding(.trailing, 16)
            
        case let .oneIcon(action, icon):
            makeIconItem(action: action, icon: icon)
                .padding(.trailing, 16)
            
        case .pop:
            makeIcon(icon: CommonFeatureAsset.Images.icoClose.swiftUIImage)
                .padding(.trailing, 20)
            
        case .none:
            EmptyView()
                .padding(.trailing, 16)
        }
    }
    
    @ViewBuilder
    private func makeIconItem(action: @escaping () -> Void, icon: Image) -> some View {
        Button {
            action()
        } label: {
            makeIcon(icon: icon)
        }
    }
    
    @ViewBuilder
    private func makeIcon(icon: Image) -> some View {
        icon
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundStyle(tintColor)
    }
}
