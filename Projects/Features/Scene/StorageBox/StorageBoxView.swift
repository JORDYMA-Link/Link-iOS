//
//  StorageBoxView.swift
//  Blink
//
//  Created by kyuchul on 4/27/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture
import SwiftUIIntrospect

public struct StorageBoxView: View {
  @Perception.Bindable var store: StoreOf<StorageBoxFeature>
  @StateObject var scrollViewDelegate = StorageBoxScrollViewDelegate()
  @State private var isScrollDetected = false
  
  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        StorageBoxNavigationView(isScrollDetected: $isScrollDetected)
        
        ScrollView(showsIndicators: false) {
          VStack(spacing: 0) {
            BKSearchBanner(
              searchAction: { store.send(.searchBannerTapped) },
              calendarAction: {}
            )
            .storageBoxBannerBackgroundView()
            
            Divider()
              .foregroundStyle(Color.bkColor(.gray400))
            
            LazyVGrid(
              columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible())],
              spacing: 16
            ) {
              if store.isAddFolder {
                AddStorageBoxItem(action: { store.send(.addStorageBoxTapped) })
              }
              
              ForEach(store.folderList) { item in
                StorageBoxItem(
                  count: item.feedCount,
                  name: item.name,
                  menuAction: { store.send(.storageBoxMenuTapped(item)) },
                  itemAction: { store.send(.storageBoxTapped(item)) }
                )
              }
            }
            .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 16))
          }
        }
        .background(Color.bkColor(.gray300))
        .introspect(.scrollView, on: .iOS(.v16, .v17)) { scrollView in
          scrollView.delegate = scrollViewDelegate
        }
      }
      .padding(.bottom, 52)
      .background(Color.bkColor(.white))
      .navigationDestination(
        item: $store.scope(
          state: \.searchKeyword,
          action: \.searchKeyword
        )
      ) { store in
        SearchView(store: store)
      }
      .navigationDestination(
        item: $store.scope(
          state: \.storageBoxFeedList,
          action: \.storageBoxFeedList
        )
      ) { store in
        StorageBoxFeedListView(store: store)
      }
      .onReceive(scrollViewDelegate.$isScrollDetected.receive(on: DispatchQueue.main)) {
        isScrollDetected = $0
      }
      .onViewDidLoad { store.send(.onViewDidLoad) }
    }
  }
}

private struct StorageBoxNavigationView: View {
  @Binding var isScrollDetected: Bool
  
  var body: some View {
    VStack(spacing: 0) {
      makeBKNavigationView(leadingType: .tab("보관함"), trailingType: .none)
        .padding(.horizontal, 16)
      
      Divider()
        .foregroundStyle(Color.bkColor(.gray400))
        .opacity(isScrollDetected ? 1 : 0)
    }
  }
}

extension View {
  func storageBoxBannerBackgroundView() -> some View {
    ZStack {
      Color.bkColor(.white)
      self
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 24, trailing: 16))
    }
  }
}

@MainActor
final class StorageBoxScrollViewDelegate: NSObject, UIScrollViewDelegate, ObservableObject {
  @Published var isScrollDetected = false
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    DispatchQueue.main.async {
      self.isScrollDetected = scrollView.contentOffset.y > 80
    }
  }
}
