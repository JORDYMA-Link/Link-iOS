//
//  StorageBoxView.swift
//  Blink
//
//  Created by kyuchul on 4/27/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

struct StorageBoxView: View {
    @State private var contentText: String = ""
    
    let columns: [GridItem] = [GridItem(.flexible(), spacing: 14), GridItem(.flexible())]
    
    var body: some View {
        VStack {
            TextField("콘텐츠를 찾아드립니다.", text: $contentText)
                .frame(height: 43)
                .background(Color.bkColor(.gray300))
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 16) {
                    Rectangle()
                        .frame(height: 80)
                        .foregroundColor(Color.red)
                    
                    ForEach(1..<20) { index in
                        Rectangle()
                            .frame(height: 80)
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.vertical, 32)
            }
            .padding(.horizontal, 16)
            .background(Color.bkColor(.gray300))
        }
        .background(Color.bkColor(.white))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                LeadingItem(type: .tab("보관함"))
            }
        }
    }
}

#Preview {
    NavigationStack {
        StorageBoxView()
    }
}
