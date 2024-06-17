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
public struct BKTabFeature: Reducer {
  public init() {}
  
  @ObservableState
  public struct State: Equatable {
        var currentItem: BKTabViewType = .home
        var showMenu = false
        var pushSaveLink = false
        
        var home: HomeFeature.State = .init()
        var storageBox: StorageBoxFeature.State = .init()
    
        public init() {}
    }
    
  public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)
        case centerCircleIconTapped
        case dimmViewTapped
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
            case .centerCircleIconTapped:
                state.showMenu.toggle()
                return .none
            case .dimmViewTapped:
                state.showMenu = false
                return .none
            case .saveLinkButtonTapped:
                state.pushSaveLink = true
                return . none
            case .storageBox:
                return .none
            case .home:
                return .none
            case .binding:
                return .none
            }
        }
    }
}
