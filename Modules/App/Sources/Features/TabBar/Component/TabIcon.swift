//
//  TabIcon.swift
//  Blink
//
//  Created by 김규철 on 2024/04/08.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

struct TabIcon: View {
    @Perception.Bindable var store: StoreOf<BKTabFeature>
    @Binding var showMenu: Bool
    let tabViewType: BKTabViewType
    
    var body: some View {
        WithPerceptionTracking {
            Button {
                store.currentItem = tabViewType
                withAnimation {
                    showMenu = false
                }
            } label: {
                (store.currentItem == tabViewType ? tabViewType.selectedImage : tabViewType.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 24, height: 24)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
