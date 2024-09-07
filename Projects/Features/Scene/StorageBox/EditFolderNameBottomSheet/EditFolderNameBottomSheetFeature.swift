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
    
    public var isEditFolderBottomSheetPresented: Bool = false
    
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    // MARK: User Action
    case editFolderNameTapped(Folder)
    case closeButtonTapped
    case textChanged(String)
    case confirmButtonTapped
    
    // MARK: Inner Business Action
    case successEditFolderName
    
    // MARK: Inner SetState Action
    case setValidation(Bool)
        
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
        
      case let .textChanged(name):
        state.folder.name = name
        
        if state.folder.name.isEmpty || state.folder.name.count > 10 {
          state.folderErrorType = .textcount
          return .send(.setValidation(false))
        }
        
        if state.folder.name.isValidLeadingTrailingWhitespace() {
          state.folderErrorType = .hasprefix
          return .send(.setValidation(false))
        }
        
        return .send(.setValidation(true))
        
      case .closeButtonTapped:
        state.isEditFolderBottomSheetPresented = false
        return .none
        
      case .confirmButtonTapped:
        return .run(
          operation: { [state] send in
            let fetchFolder = try await folderClient.patchFolder(state.folder.id, state.folder.name)
            
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
        
      case let .setValidation(isValidation):
        state.isValidation = isValidation
        return .none
                
      default:
        return .none
      }
    }
  }
}
