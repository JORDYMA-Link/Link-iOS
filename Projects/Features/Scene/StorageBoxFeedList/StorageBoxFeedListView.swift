//
//  StorageBoxFeedListView.swift
//  Blink
//
//  Created by 김규철 on 5/5/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture
import SwiftUIIntrospect

struct StorageBoxFeedListView: View {
  @Perception.Bindable var store: StoreOf<StorageBoxFeedListFeature>
  @StateObject var scrollViewDelegate = ScrollViewDelegate()
  @State private var isScrollDetected: Bool = false
  
  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        StorageBoxFeedListNavigationBar(
          store: store,
          isScrollDetected: $isScrollDetected
        )
        
        ScrollView(showsIndicators: false) {
          VStack(spacing: 0) {
            BKSearchBanner(
              searchAction: {},
              calendarAction: {}
            )
            .storageBoxBannerBackgroundView()
            
            Divider()
              .foregroundStyle(Color.bkColor(.gray400))
            
            StorageBoxFeedListHeader(store: store)
              .padding(EdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 16))
              .background(ViewMaxYGeometry())
              .onPreferenceChange(ViewPreferenceKey.self) { maxY in
                let navigationBarMaxY = (UIApplication.topSafeAreaInset - 20)
                let headerMaxY = maxY + navigationBarMaxY
                
                DispatchQueue.main.async {
                  scrollViewDelegate.headerMaxY = headerMaxY
                }
              }
            
            StorageBoxFeedListCardView(store: store)
          }
        }
        .background(Color.bkColor(.gray300))
        .introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
          scrollView.delegate = scrollViewDelegate
        }
      }
      .toolbar(.hidden, for: .navigationBar)
      .animation(.easeIn(duration: 0.2), value: isScrollDetected)
      .onReceive(scrollViewDelegate.$isScrollDetected.receive(on: DispatchQueue.main)) {
        self.isScrollDetected = $0
      }
    }
  }
}

private struct StorageBoxFeedListNavigationBar: View {
  @Perception.Bindable private var store: StoreOf<StorageBoxFeedListFeature>
  @Binding var isScrollDetected: Bool
  
  init(
    store: StoreOf<StorageBoxFeedListFeature>,
    isScrollDetected: Binding<Bool>
  ) {
    self.store = store
    self._isScrollDetected = isScrollDetected
  }
  
  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        if !isScrollDetected {
          navigationbar()
        } else {
          scrollNavigationbar()
        }
        
        Divider()
          .foregroundStyle(Color.bkColor(.gray400))
          .opacity(!isScrollDetected ? 0 : 1)
      }
    }
  }
  
  @ViewBuilder
  private func navigationbar() -> some View {
    makeBKNavigationView(leadingType: .tab("보관함"), trailingType: .none)
      .padding(.horizontal, 16)
  }
  
  @ViewBuilder
  private func scrollNavigationbar() -> some View {
    StorageBoxFeedListHeader(store: store)
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity, minHeight: 56, maxHeight: 56)
      .background(Color.bkColor(.white))
  }
}
