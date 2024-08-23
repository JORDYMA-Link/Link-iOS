//
//  EditFolderBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 6/23/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct EditFolderBottomSheetFeature {
  @ObservableState
  public struct State: Equatable {
    public var folderList: [Folder] = []
    public var selectedFolder: Folder = .init(id: 0, name: "", feedCount: 0)
    
    public var isEditFolderBottomSheetPresented: Bool = false
    
    public var addFolderBottomSheet: AddFolderBottomSheetFeature.State = .init()
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case onTask
    case editFolderTapped(String)
    case folderCellTapped(Folder)
    case closeButtonTapped
        
    // MARK: Inner Business Action
    case fetchFolderList
    
    // MARK: Inner SetState Action
    case setFolderList([Folder])
    case setSelectedFolder(Folder)
    
    // MARK: Delegate Action
    public enum Delegate {
      case didUpdateFolder(Folder)
    }
    case delegate(Delegate)
    
    // MARK: Child Action
    case addFolderBottomSheet(AddFolderBottomSheetFeature.Action)
  }
  
  @Dependency(\.folderClient) private var folderClient
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet) {
      AddFolderBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .onTask:
        return .send(.fetchFolderList)
        
      case .editFolderTapped:
        state.isEditFolderBottomSheetPresented = true
        return .none
        
      case let .folderCellTapped(folder):
        state.isEditFolderBottomSheetPresented = false
        return .send(.delegate(.didUpdateFolder(folder)))
        
      case .closeButtonTapped:
        state.isEditFolderBottomSheetPresented = false
        return .none
        
      case .fetchFolderList:
        return .run(
          operation: { send in
            let folderList = try await folderClient.getFolders()
            
            if let selectedFolder = folderList.first {
              await send(.setSelectedFolder(selectedFolder))
            }
            
            await send(.setFolderList(folderList), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )
                
      case let .setFolderList(folderList):
        state.folderList = folderList
        return .none
        
      case let .setSelectedFolder(folder):
        state.selectedFolder = folder
        return .none
        
      case .addFolderBottomSheet(.delegate(.fetchFolderList)):
        print("폴더 추가 완료하여 Get 폴더 리스트 API 콜")
        return .none
        
      default:
        return .none
      }
    }
  }
}
