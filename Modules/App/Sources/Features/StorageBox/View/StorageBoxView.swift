//
//  StorageBoxView.swift
//  Blink
//
//  Created by kyuchul on 4/27/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

struct StorageBoxView: View {
    var body: some View {
        ZStack {
            Color.bkColor(.gray300)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                makeBKNavigationView(leadingType: .tab("보관함"), trailingType: .none)
                
                Spacer()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    StorageBoxView()
}
