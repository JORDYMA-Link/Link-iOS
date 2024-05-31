//
//  LoginView.swift
//  Blink
//
//  Created by kyuchul on 5/31/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct LoginView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 0) {
                ZStack {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color.bkColor(.main300))
                        .frame(width: 135, height: 135)
                    
                    BKIcon(image: CommonFeatureAsset.Images.logoWhite.swiftUIImage, color: .white, size: CGSize(width: 64, height: 70))
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
