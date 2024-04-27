//
//  KeywordChipView.swift
//  Blink
//
//  Created by 김규철 on 2024/04/21.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct KeywordChipView: View {
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                keywordText
                keywordText
                keywordText
            }
        }
    }
    
    private var keywordText: some View {
        Text("Design System")
            .font(.semiBold(size: ._11))
            .foregroundColor(.bkColor(.gray700))
            .padding(.vertical, 5)
            .padding(.horizontal, 9)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.bkColor(.gray500), lineWidth: 1)
            )
    }
    
}
