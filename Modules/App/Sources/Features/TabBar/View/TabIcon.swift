//
//  TabIcon.swift
//  Blink
//
//  Created by 김규철 on 2024/04/08.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct TabIcon: View {
    let tabViewType: TabViewType
    @ObservedObject var viewModel: BKTabViewModel
    @Binding var showMenu: Bool
    
    var body: some View {
        Button() {
            viewModel.currentItem = tabViewType
            withAnimation {
                showMenu = false
            }
        } label: {
            (viewModel.currentItem == tabViewType ? tabViewType.selectedImage : tabViewType.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 24, height: 24)
                .frame(maxWidth: .infinity)
        }
    }
}
