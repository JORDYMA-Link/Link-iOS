//
//  BKIcon.swift
//  CommonFeature
//
//  Created by 김규철 on 5/5/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

public struct BKIcon: View {
    public var image: Image
    public var color: Color
    public var size: CGSize
    
    public init(image: Image, color: Color, size: CGSize) {
        self.image = image
        self.color = color
        self.size = size
    }
    
    public var body: some View {
       image
            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: size.width, height: size.height)
            .foregroundStyle(color)
    }
}
