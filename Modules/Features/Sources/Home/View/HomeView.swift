//
//  HomeView.swift
//  Features
//
//  Created by 김규철 on 2024/04/01.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI
import Combine

public struct HomeView: View {
    
    @StateObject private var viewModel = HomeDIContainer().makeViewModel()
    
    public init() {}
    
    public var body: some View {
        Text("Hello, World!")
            .onAppear {
                viewModel.loadCoinData()
            }
#if DEBUG
        Text("Debug")
#endif
    }
}

