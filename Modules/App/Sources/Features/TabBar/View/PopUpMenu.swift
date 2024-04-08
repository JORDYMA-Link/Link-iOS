//
//  PopUpMenu.swift
//  Blink
//
//  Created by 김규철 on 2024/04/07.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct PopUpMenu: View {
    var body: some View {
        HStack(spacing: 24) {
            Spacer()
            Spacer()
            Spacer()
            
            ForEach(PopUpMenuType.allCases, id: \.self) { item in
                MenuItem(menuType: item)
            }
      
            Spacer()
            Spacer()
            Spacer()
        }
        .transition(.scale)
    }
}

struct MenuItem: View {
    let menuType: PopUpMenuType
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            ZStack {
                Circle()
                    .foregroundColor(Color.bkColor(.white))
                    .frame(width: 56, height: 56)
                
                menuType.image
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(Color.bkColor(.main300))
            }
            
            Text(menuType.title)
                .foregroundColor(Color.bkColor(.white))
                .font(.semiBold(size: BKFont.BodySize.Body1))
        }
    }
}

struct PopUpMenu_Previews: PreviewProvider {
    static var previews: some View {
        PopUpMenu()
    }
}
