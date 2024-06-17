//
//  ClearableTextField.swift
//  CommonFeature
//
//  Created by 문정호 on 5/10/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

public struct ClearableTextField: View {
    @Binding var text: String
    var placeholder: String
    let showClearButton: Bool
    
    
    public init(text: Binding<String>, placeholder: String, showClearButton: Bool = true) {
        self._text = text
        self.placeholder = placeholder
        self.showClearButton = showClearButton
    }
    
    public var body: some View {
        TextField(text: $text) {
            Text("링크를 붙여주세요")
                .font(.regular(size: ._14))
                .foregroundStyle(Color.bkColor(.gray800))
        }
        .frame(height: 46)
        .padding(.leading, 10)
        .background(Color.bkColor(.gray300))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        overlay(
            HStack {
                Spacer()
                if showClearButton && !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "multiply.circle.fill")
                            .foregroundStyle(Color.gray)
                    }
                    .padding(.trailing, 10)
                }
            }
        )
    }
}
