//
//  AddFolderBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models
import Services

import ComposableArchitecture

@Reducer
public struct AddFolderBottomSheetFeature {
  @ObservableState
  public struct State: Equatable {
    public var folderName: String = ""
    public var isValidation: Bool = true
    public var isAddFolderBottomSheetPresented: Bool = false
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case addFolderTapped
    case closeButtonTapped
    case confirmButtonTapped
    
    // MARK: Inner Business Action
    case successAddFolder
        
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
      case .binding(\.folderName):
        return .none
        
      case .addFolderTapped:
        state.isAddFolderBottomSheetPresented = true
        return .none
        
      case .closeButtonTapped:
        state.folderName = ""
        state.isAddFolderBottomSheetPresented = false
        return .none
        
      case .confirmButtonTapped:
        return .run(
          operation: { [state] send in
            let addFolder = try await folderClient.postFolder(state.folderName)
            
            print(addFolder)
            
            await send(.successAddFolder)
          },
          catch: { error, send in
            print(error)
          }
        )
        .throttle(id: ThrottleId.confirmButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case .successAddFolder:
        state.folderName = ""
        state.isAddFolderBottomSheetPresented = false
        return .send(.delegate(.fetchFolderList))
                        
      default:
        return .none
      }
    }
  }
}
