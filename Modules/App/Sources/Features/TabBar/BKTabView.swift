//
//  BKTabView.swift
//  Blink
//
//  Created by 김규철 on 2024/04/07.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

// MARK: - BKTabViewType

enum BKTabViewType: Int, CaseIterable {
    case home
    case folder
    
    var image: Image {
        switch self {
        case .home:
            return CommonFeatureAsset.Images.icoHome.swiftUIImage
        case .folder:
            return CommonFeatureAsset.Images.icoFolder.swiftUIImage
        }
    }
    
    var selectedImage: Image {
        switch self {
        case .home:
            return CommonFeatureAsset.Images.icoHomeClcik.swiftUIImage
        case .folder:
            return CommonFeatureAsset.Images.icoFolderClick.swiftUIImage
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .home:
            HomeView(store: .init(initialState: HomeFeature.State()) {
                HomeFeature()
            })
        case .folder:
            StorageBoxView(store: .init(initialState: StorageBoxFeature.State()) {
                StorageBoxFeature()
            })
        }
    }
}

// MARK: - BKTabbar

struct BKTabView: View {
    @Perception.Bindable var store: StoreOf<BKTabFeature>
    
    var body: some View {
        NavigationStack {
            WithPerceptionTracking {
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        Spacer(minLength: 0)
                        
                        ZStack {
                            store.currentItem.view
                            
                            if store.showMenu {
                                Color.bkColor(.black).opacity(0.6)
                                    .edgesIgnoringSafeArea(.all)
                                    .onTapGesture {
                                        store.send(.dimmViewTapped, animation: .default)
                                    }
                            }
                        }
                        
                        Spacer(minLength: 0)
                        
                        Color.bkColor(.gray300)
                            .frame(height: 1)
                            .frame(maxWidth: .infinity)
                        
                        HStack {
                            Spacer()
                            Spacer()
                            Spacer()
                            
                            VStack {
                                TabIcon(store: store, showMenu: $store.showMenu, tabViewType: .home)
                                    .padding(.top, 15)
                                
                                Spacer()
                            }
                            
                            TabCircleIcon(showMenu: $store.showMenu)
                                .onTapGesture {
                                    store.send(.centerCircleIconTapped, animation: .default)
                                }
                            
                            VStack {
                                TabIcon(store: store, showMenu: $store.showMenu, tabViewType: .folder)
                                    .padding(.top, 15)
                                
                                Spacer()
                            }
                            
                            Spacer()
                            Spacer()
                            Spacer()
                        }
                        .frame(height: 82)
                        .frame(maxWidth: .infinity)
                        .background(Color.bkColor(.white))
                    }
                    
                    if store.showMenu {
                        PopUpMenu(saveLinkAction: { store.send(.saveLinkButtonTapped)
                        })
                            .padding(.bottom, 144)
                    }
                }
                .ignoresSafeArea(edges: .bottom)
                .toolbar(.hidden, for: .tabBar)
                .navigationDestination(isPresented: $store.pushSaveLink) {
                    SaveLinkView()
                }
            }
        }
    }
}

#Preview {
    BKTabView(store: .init(initialState: BKTabFeature.State()) {
        BKTabFeature()
            ._printChanges()
    })
}
