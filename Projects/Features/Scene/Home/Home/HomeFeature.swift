//
//  HomeFeature.swift
//  Blink
//
//  Created by kyuchul on 6/7/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct HomeFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    public var linkPostMenuBottomSheet: LinkPostMenuBottomSheetFeature.State = .init()
    public var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    
  }
  
  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case leadingSwipeAction(LinkCard)
    
    // MARK: Child Action
    case linkPostMenuBottomSheet(LinkPostMenuBottomSheetFeature.Action)
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    
    // MARK: Inner Business Action
    
    // MARK: Inner SetState Action
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.linkPostMenuBottomSheet, action: \.linkPostMenuBottomSheet) {
      LinkPostMenuBottomSheetFeature()
    }
    Scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet) {
      EditFolderBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case let .leadingSwipeAction(linkPost):
        return .send(.editFolderBottomSheet(.editFolderTapped(linkPost.id)))
        
      default:
        return .none
      }
    }
  }
}


