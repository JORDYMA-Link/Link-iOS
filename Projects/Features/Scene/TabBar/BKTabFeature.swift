//
//  BKTabFeature.swift
//  Blink
//
//  Created by kyuchul on 6/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct BKTabFeature {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
    var currentItem: BKTabViewType = .home
    var isSaveContentPresented = false
    var isSaveLinkPresented = false
    
    var home: HomeFeature.State = .init()
    var storageBox: StorageBoxFeature.State = .init()
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case roundedTabIconTapped
    case saveLinkButtonTapped
    
    case storageBox(StorageBoxFeature.Action)
    case home(HomeFeature.Action)
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.storageBox, action: \.storageBox) { StorageBoxFeature() }
    Scope(state: \.home, action: \.home) { HomeFeature() }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .roundedTabIconTapped:
        state.isSaveContentPresented.toggle()
        return .none

      case .saveLinkButtonTapped:
        state.isSaveContentPresented.toggle()
        state.isSaveLinkPresented = true
        return . none
        
      default:
        return .none
      }
    }
  }
}
