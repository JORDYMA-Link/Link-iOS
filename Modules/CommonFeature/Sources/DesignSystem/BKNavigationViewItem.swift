//
//  BKNavigationViewItem.swift
//  CommonFeature
//
//  Created by 김규철 on 5/5/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

// MARK: - LeadingItemTypes

public enum LeadingItemTypes {
    case home
    case tab(String)
    case pop(String)
    case dismiss(String, () -> Void)
}

// MARK: - LeadingItem

public struct LeadingItem: View {
    public var type: LeadingItemTypes
    
    public init(type: LeadingItemTypes) {
        self.type = type
    }
    
    public var body: some View {
        switch type {
        case .home:
            CommonFeatureAsset.Images.homeLogo.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 67, height: 32, alignment: .leading)
            
        case let .tab(text):
            makeLeadingTextItem(title: text, font: .semiBold(size: ._18), textColor: .bkColor(.gray600))
            
        case let .pop(text):
            makeLeadingTextItem(title: text, font: .semiBold(size: ._16), textColor: .bkColor(.black))
                .padding(.leading, 20)
            
        case let .dismiss(text, action):
            Button {
                action()
            } label: {
                HStack(spacing: 4) {
                    CommonFeatureAsset.Images.icoChevronLeft.swiftUIImage
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.bkColor(.gray900))
                    
                    makeLeadingTextItem(title: text, font: .semiBold(size: ._16), textColor: .bkColor(.gray900))
                }
            }
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

public enum TrailingItemTypes {
    case twoIcon(leftAction: () -> Void, rightAction: () -> Void, leftIcon: Image, rightIcon: Image)
    case oneIcon(action: () -> Void, icon: Image)
    case pop
    case none
}

// MARK: - TrailingItem

public struct TrailingItem: View {
    public var type: TrailingItemTypes
    public var tintColor: Color
    
    public init(type: TrailingItemTypes, tintColor: Color) {
        self.type = type
        self.tintColor = tintColor
    }
    
    public var body: some View {
        switch type {
        case let .twoIcon(leftAction, rightAction, leftIcon, rightIcon):
            HStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 18) {
                makeIconItem(action: leftAction, icon: leftIcon)
                makeIconItem(action: rightAction, icon: rightIcon)
            }
            
        case let .oneIcon(action, icon):
            makeIconItem(action: action, icon: icon)
            
        case .pop:
            makeIcon(icon: CommonFeatureAsset.Images.icoClose.swiftUIImage)
                .padding(.trailing, 20)
            
        case .none:
            EmptyView()
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
