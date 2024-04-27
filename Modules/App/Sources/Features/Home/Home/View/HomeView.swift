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
            VStack {
                HStack {
                    Text("asad")
                }
                ScrollView {
                    Text("비트코인 2억간다.")
                        .foregroundColor(Color.bkColor(.green))
                    Text("비트코인 3억간다.")
                        .foregroundColor(Color.bkColor(.main700))
                        .font(.semiBold(size: ._56))
                }
                .background(.pink)
            }
            .onAppear {
                viewModel.loadCoinData()
            }
    }
}


