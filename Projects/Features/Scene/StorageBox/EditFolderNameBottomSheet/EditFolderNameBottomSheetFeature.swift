//
//  EditFolderNameBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 6/18/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models
import Services

import ComposableArchitecture

@Reducer
public struct EditFolderNameBottomSheetFeature {
  @ObservableState
  public struct State: Equatable {
    public var folder: Folder = .init(id: 0, name: "", feedCount: 0)
    public var isValidation: Bool = false
    public var isEditFolderBottomSheetPresented: Bool = false
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    // MARK: User Action
    case editFolderNameTapped(Folder)
    case closeButtonTapped
    case confirmButtonTapped
    
    // MARK: Inner Business Action
    case successEditFolderName
        
    // MARK: Delegate Action
    public enum Delegate {
      case fetchFolderList
    }
    case delegate(Delegate)
  }
  
  @Dependency(\.folderClient) private var folderClient
  
  private enum ThrottleId {
    case confirmButton
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.folder.name):
        return .none
        
      case let .editFolderNameTapped(folder):
        state.folder = folder
        state.isEditFolderBottomSheetPresented = true
        return .none
        
      case .closeButtonTapped:
        state.isEditFolderBottomSheetPresented = false
        return .none
        
      case .confirmButtonTapped:
        return .run(
          operation: { [state] send in
            let fetchFolder = try await folderClient.fetchFolder(state.folder.id, state.folder.name)
            
            print(fetchFolder)
            
            await send(.successEditFolderName)
          },
          catch: { error, send in
            print(error)
          }
        )
        .throttle(id: ThrottleId.confirmButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case .successEditFolderName:
        state.isEditFolderBottomSheetPresented = false
        return .send(.delegate(.fetchFolderList))
                
      default:
        return .none
      }
    }
  }
}
