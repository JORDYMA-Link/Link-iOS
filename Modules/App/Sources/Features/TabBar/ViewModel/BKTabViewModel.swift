//
//  BKTabViewModel.swift
//  Blink
//
//  Created by 김규철 on 2024/04/08.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

final class BKTabViewModel: ObservableObject {
    @Published var currentItem: BKTabViewType = .home
    
    var view: some View {
        return currentItem.view
    }
    
}
