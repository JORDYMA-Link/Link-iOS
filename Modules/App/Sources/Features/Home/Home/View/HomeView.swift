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
        VStack(spacing: 0) {
            makeBKNavigationView(leadingType: .home, trailingType: .twoIcon(leftAction: {
                print("go to Alarm")
            }, rightAction: {
                print("go to setting")
            }, leftIcon: CommonFeatureAsset.Images.icoBell.swiftUIImage, rightIcon: CommonFeatureAsset.Images.icoSettings.swiftUIImage))
            
            ScrollView {
                Text("비트코인 2억간다.")
                    .foregroundColor(Color.bkColor(.green))
                Text("비트코인 3억간다.")
                    .foregroundColor(Color.bkColor(.main700))
                    .font(.semiBold(size: ._56))
            }
            .frame(maxWidth: .infinity)
            .background(.pink)
        }
        .onAppear {
            viewModel.loadCoinData()
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    HomeView()
}
