//
//  AddFolderBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct AddFolderBottomSheetFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    public var isAddFolderBottomSheetPresented: Bool = false
    public var isHighlight: Bool = true
    public var folderInput: Folder = .init(title: "", count: 0)
    public var savedFolder: Folder?
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case addFolderTapped
    case confirmButtonTapped
    case closeButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.folderInput):
        return .none
        
      case .addFolderTapped:
        state.isAddFolderBottomSheetPresented = true
        return .none
        
      case .confirmButtonTapped:
        state.savedFolder = state.folderInput
        state.isAddFolderBottomSheetPresented = true
        return .none
        
      case .closeButtonTapped:
        state.isAddFolderBottomSheetPresented = false
        return .none
        
      default:
        return .none
      }
    }
  }
}
