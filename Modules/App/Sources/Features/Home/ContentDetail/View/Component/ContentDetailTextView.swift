//
//  ContentDetailTextView.swift
//  Blink
//
//  Created by 김규철 on 2024/04/21.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct ContentDetailTextView: View {
    var text: String
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.bkColor(.gray300)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text(text)
                .font(.regular(size: ._14))
                .foregroundColor(.bkColor(.main800))
                .padding(.horizontal, 16)
                .padding(.vertical, 13)
        }
    }
}
