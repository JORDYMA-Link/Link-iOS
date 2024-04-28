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
    @State private var pushToNotification = false
    @State private var pushToSetting = false
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                Text("비트코인 2억간다.")
                    .foregroundColor(Color.bkColor(.green))
                Text("비트코인 3억간다.")
                    .foregroundColor(Color.bkColor(.main700))
                    .font(.semiBold(size: ._56))
            }
            .frame(maxWidth: .infinity)
            .background(.pink)
            .navigationDestination(isPresented: $pushToNotification, destination: {
                NotificationListView()
            })
            .navigationDestination(isPresented: $pushToSetting, destination: {
                SettingView()
            })
            .onAppear {
                viewModel.loadCoinData()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    LeadingItem(type: .home)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    TrailingItem(type: .twoIcon(leftAction: {
                        pushToNotification.toggle()
                    }, rightAction: {
                        pushToSetting.toggle()
                    }, leftIcon: CommonFeatureAsset.Images.icoBell.swiftUIImage, rightIcon: CommonFeatureAsset.Images.icoSettings.swiftUIImage), tintColor: .bkColor(.gray900)
                    )
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
