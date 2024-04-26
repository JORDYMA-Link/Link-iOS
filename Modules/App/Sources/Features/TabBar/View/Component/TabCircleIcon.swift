//
//  TabCircleIcon.swift
//  Blink
//
//  Created by 김규철 on 2024/04/08.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct TabCircleIcon: View {
    @Binding var showMenu: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(colors: [Color.bkColor(.gradient400), Color.bkColor(.gradient300),  Color.bkColor(.gradient100)], startPoint: .topLeading, endPoint: .bottomTrailing)
                  )
                .frame(width: 56, height: 56)
                .shadow(radius: 4)
            
            CommonFeatureAsset.Images.icoTabViewConceptStar.swiftUIImage
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 36, height: 36)
                .frame(maxWidth: .infinity)
                .rotationEffect(Angle(degrees: showMenu ? -50 : 0))
        }
        .offset(y: -41)
    }
}
