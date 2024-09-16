//
//  AddFolderBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Common
import Models
import Services

import ComposableArchitecture

public enum FolderValidationError: Error {
  case textcount
  case hasprefix
}

@Reducer
public struct AddFolderBottomSheetFeature {
  @ObservableState
  public struct State: Equatable {
    public var folderName: String = ""
    public var isValidation: Bool = true
    public var folderErrorType: FolderValidationError = .textcount
    public var errorMessage: String {
      switch folderErrorType {
      case .textcount:
        return "폴더 이름은 10글자 이내로 입력해주세요"
      case .hasprefix:
        return "폴더 이름 시작과 끝에는 공백을 입력할 수 없어요"
      }
    }
    
    public var isAddFolderBottomSheetPresented: Bool = false
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case addFolderTapped
    case closeButtonTapped
    case folderNameTextChanged(String)
    case confirmButtonTapped
    
    // MARK: Inner Business Action
    case successAddFolder(Folder)
    
    // MARK: Inner SetState Action
    case setValidation(Bool)
    case reset
    
    // MARK: Delegate Action
    public enum Delegate {
      case didUpdate(Folder)
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
      case .addFolderTapped:
        state.isAddFolderBottomSheetPresented = true
        return .none
        
      case .closeButtonTapped:
        state.isAddFolderBottomSheetPresented = false
        return .send(.reset)
        
      case let .folderNameTextChanged(folderName):
        state.folderName = folderName
        
        if state.folderName.isEmpty || state.folderName.count > 10 {
          state.folderErrorType = .textcount
          return .send(.setValidation(false))
        }
        
        if state.folderName.isValidLeadingTrailingWhitespace() {
          state.folderErrorType = .hasprefix
          return .send(.setValidation(false))
        }
        
        return .send(.setValidation(true))
        
      case .confirmButtonTapped:
        return .run(
          operation: { [state] send in
            let addFolder = try await folderClient.postFolder(state.folderName)
            
            print(addFolder)
            
            await send(.successAddFolder(addFolder))
          },
          catch: { error, send in
            print(error)
          }
        )
        .throttle(id: ThrottleId.confirmButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let .successAddFolder(folder):
        state.isAddFolderBottomSheetPresented = false
        return .run { send in
          await send(.reset)
          await send(.delegate(.didUpdate(folder)))
        }
        
      case let .setValidation(isValidation):
        state.isValidation = isValidation
        return .none
        
      case .reset:
        state.folderName = ""
        state.isValidation = true
        return .none
        
      default:
        return .none
      }
    }
  }
}
