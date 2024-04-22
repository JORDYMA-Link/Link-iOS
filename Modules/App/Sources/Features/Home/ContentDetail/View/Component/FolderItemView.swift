//
//  FolderItemView.swift
//  Blink
//
//  Created by 김규철 on 2024/04/21.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct FolderItemView: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.regular(size: BKFont.BodySize.Body2))
            .foregroundColor(.bkColor(.gray900))
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.bkColor(.gray500), lineWidth: 1)
            )
    }
}
