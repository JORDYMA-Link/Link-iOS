//
//  EditFolderNameBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 6/18/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct EditFolderNameBottomSheetFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    public var isEditFolderBottomSheetPresented: Bool = false
    public var isHighlight: Bool = false
    public var folderInput: Folder = .init(title: "", count: 0)
    public var savedFolder: Folder?
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case editFolderNameTapped(Folder)
    case confirmButtonTapped
    case closeButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.folderInput):
        return .none
        
      case let .editFolderNameTapped(folder):
        state.isEditFolderBottomSheetPresented = true
        state.folderInput = folder
        return .none
        
      case .confirmButtonTapped:
        state.isEditFolderBottomSheetPresented = true
        return .none
        
      case .closeButtonTapped:
        state.isEditFolderBottomSheetPresented = false
        return .none
        
      default:
        return .none
      }
    }
  }
}
