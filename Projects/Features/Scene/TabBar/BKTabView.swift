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
      return CommonFeature.Images.icoHome
    case .folder:
      return CommonFeature.Images.icoFolder
    }
  }
  
  var selectedImage: Image {
    switch self {
    case .home:
      return CommonFeature.Images.icoHomeClcik
    case .folder:
      return CommonFeature.Images.icoFolderClick
    }
  }
}

// MARK: - BKTabbar

public struct BKTabView: View {
  @Perception.Bindable var store: StoreOf<BKTabFeature>
  
  public init(store: StoreOf<BKTabFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      WithPerceptionTracking {
        TabView(selection: $store.currentItem) {
          switch store.currentItem {
          case .home:
            HomeContainerView(store: store.scope(state: \.home, action: \.home), tabbar: tabbar)
          case .folder:
            StorageBoxContainerView(store: store.scope(state: \.storageBox, action: \.storageBox), tabbar: tabbar)
          }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
          UITabBar.appearance().isHidden = true
        }
        .navigationDestination(isPresented: $store.isSaveLinkPresented) {
          SaveLinkView(store: Store(initialState: SaveLinkFeature.State(), reducer: { SaveLinkFeature() } ))
        }
      }
    }
  }
}

extension BKTabView {
  private var tabbar: some View {
    VStack(spacing: 0) {
      Divider()
        .foregroundStyle(Color.bkColor(.gray400))
      
      HStack(spacing: 0) {
        ForEach(BKTabViewType.allCases, id: \.self) { tab in
          let isSelected: Bool = store.currentItem == tab
          
          Group {
            (isSelected ? tab.selectedImage : tab.image)
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 24, height: 24)
          }
          .frame(maxWidth: .infinity)
          .onTapGesture {
            store.send(.binding(.set(\.currentItem, tab)))
          }
        }
      }
      .padding(.vertical, 13)
    }
    .frame(height: 52, alignment: .top)
    .background(Color.white)
    .overlay {
      BKRoundedTabIcon(isPresented: $store.isSaveContentPresented)
        .onTapGesture {
          store.send(.roundedTabIconTapped, animation: .default)
        }
    }
    .presentSaveContent($store.isSaveContentPresented, action: { store.send(.saveLinkButtonTapped) })
  }
}
