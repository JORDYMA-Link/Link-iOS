//
//  BKTabView.swift
//  Blink
//
//  Created by 김규철 on 2024/04/07.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct BKTabView: View {
    @State private var showMenu = false
    @ObservedObject var viewModel = BKTabViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    
                    ZStack {
                        viewModel.view
                        
                        if showMenu {
                            Color.bkColor(.black).opacity(0.6)
                                .edgesIgnoringSafeArea(.all)
                                .onTapGesture {
                                    withAnimation {
                                        showMenu = false
                                    }
                                }
                            }
                        }
                    
                    Spacer(minLength: 0)
                    
                    HStack {
                        Spacer()
                        Spacer()
                        
                        VStack {
                            TabIcon(tabViewType: .home, viewModel: viewModel, showMenu: $showMenu)
                                .padding(.top, 15)
                            
                            Spacer()
                        }
                        
                        TabCircleIcon(showMenu: $showMenu)
                            .onTapGesture {
                                withAnimation {
                                    showMenu.toggle()
                                }
                            }
                        
                        VStack {
                            TabIcon(tabViewType: .folder, viewModel: viewModel, showMenu: $showMenu)
                                .padding(.top, 15)
                            
                            Spacer()
                        }
                        
                        Spacer()
                        Spacer()
                    }
                    .frame(height: 82)
                    .frame(maxWidth: .infinity)
                    .background(Color.bkColor(.white))
                }
                
                if showMenu {
                    PopUpMenu()
                        .padding(.bottom, 144)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BKTabView()
    }
}
