//
//  StorageBoxFeedListFeature.swift
//  Features
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct StorageBoxFeedListFeature {
  @ObservableState
  public struct State: Equatable {
    public var sortFolderBottomSheet: SortFolderBottomSheetFeature.State = .init()
    
    public var folderInput: Folder
    public var folderFeedList: [FeedCard] = []
    
    public init(folder: Folder) {
      self.folderInput = folder
    }
  }

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case closeButtonTapped
    
    // MARK: Child Action
    case sortFolderBottomSheet(SortFolderBottomSheetFeature.Action)
  }
  
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.sortFolderBottomSheet, action: \.sortFolderBottomSheet) {
      SortFolderBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.folderInput):
        return .none
                
      case .closeButtonTapped:
         return .run { _ in await self.dismiss() }
    
      default:
        return .none
      }
    }
  }
}
