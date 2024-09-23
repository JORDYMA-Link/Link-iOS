//
//  HomeContainerView.swift
//  Features
//
//  Created by kyuchul on 7/28/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

struct HomeContainerView<Content: View>: View {
  private let store: StoreOf<HomeFeature>
  private let tabbar: () -> Content
    
  public init(
    store: StoreOf<HomeFeature>,
    tabbar: @autoclosure @escaping () -> Content
  ) {
    self.store = store
    self.tabbar = tabbar
  }
  
  var body: some View {
    WithPerceptionTracking {
      ZStack(alignment: .bottom) {
        HomeView(store: store)
          .summaryToast(store: store)
        
        tabbar()
      }
      .cardSettingBottomSheet(store: store)
      .editFolderBottomSheet(store: store)
      .addFolderBottomSheet(store: store)
      .editLinkFullScreenOver(store: store)
      .toolbar(.hidden, for: .navigationBar)
    }
  }
}
