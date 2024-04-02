//
//  HomeView.swift
//  Features
//
//  Created by 김규철 on 2024/04/01.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI
import Combine
import CommonFeature
import SwiftUIIntrospect

public struct HomeView: View {
    
    @StateObject private var viewModel = HomeDIContainer().makeViewModel()
    
    public init() {}
    
    public var body: some View {
        Text("비트코인 2억간다.")
            .foregroundColor(Color.bkColor(.red))
        Text("비트코인 3억간다.")
            .foregroundColor(Color.bkColor(.main700))
            .font(.semiBold(size: BKFont.DisplaySize.Display1))
            .onAppear {
                viewModel.loadCoinData()
            }
#if DEBUG
        Text("Debug")
#endif
    }
}

public struct HomeView_Previews: PreviewProvider {
    public static var previews: some View {
        HomeView()
    }
}

