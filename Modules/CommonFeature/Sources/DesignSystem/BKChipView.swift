//
//  BKChipView.swift
//  CommonFeature
//
//  Created by 김규철 on 5/5/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

public struct BKChipView: View {
    @State private var keyword: [String]
    public var textColor: Color
    public var strokeColor: Color
    public var font: Font
    
    public init(keyword: [String], textColor: Color, strokeColor: Color, font: Font) {
        self.keyword = keyword
        self.textColor = textColor
        self.strokeColor = strokeColor
        self.font = font
    }
    
    public var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(keyword, id: \.self) { text in
                    chipTextItem(text)
                }
            }
        }
    }
    
    private func chipTextItem(_ text: String)  -> some View {
        Text(text)
            .font(font)
            .foregroundColor(textColor)
            .padding(.vertical, 5)
            .padding(.horizontal, 9)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(strokeColor, lineWidth: 1)
            )
    }
}

