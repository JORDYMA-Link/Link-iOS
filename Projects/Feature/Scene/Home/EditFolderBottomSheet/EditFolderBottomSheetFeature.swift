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
    public var feedId: Int = 0
    public var folderList: [Folder] = []
    /// 피드에 설정되어 있는 폴더
    public var initSelectedFolder: Folder = .init(id: 0, name: "", feedCount: 0)
    /// 폴더 아이템 선택
    public var selectedFolder: Folder?
    
    public var isEditFolderBottomSheetPresented: Bool = false
    
    public var addFolderBottomSheet: AddFolderBottomSheetFeature.State = .init()
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case editFolderTapped(Int, String)
    case folderCellTapped(Folder)
    case closeButtonTapped
    
    // MARK: Inner Business Action
    case fetchFolderList(String)
    case patchFeedFolder(Int, String)
    
    // MARK: Inner SetState Action
    case setFolderList([Folder])
    case setSelectedFolder(Folder)
    
    // MARK: Delegate Action
    public enum Delegate {
      case didUpdateFolder(Int, Folder)
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
      case let .editFolderTapped(feedId, folderName):
        state.feedId = feedId
        state.isEditFolderBottomSheetPresented = true
        return .send(.fetchFolderList(folderName))
        
      case let .folderCellTapped(folder):
        state.selectedFolder = folder
        return .run { [state] send in await send(.patchFeedFolder(state.feedId, folder.name)) }
        
      case .closeButtonTapped:
        state.folderList = []
        state.isEditFolderBottomSheetPresented = false
        return .none
        
      case let .fetchFolderList(folderName):
        return .run(
          operation: { send in
            var folderList = try await folderClient.getFolders()
            
            var selectedFolder: Folder?
            
            if let index = folderList.firstIndex(where: { $0.name == folderName }) {
              selectedFolder = folderList[index]
              folderList.remove(at: index)
            }
            
            if let selectedFolder {
              folderList.insert(selectedFolder, at: 0)
              await send(.setSelectedFolder(selectedFolder))
            }
            
            await send(.setFolderList(folderList), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .patchFeedFolder(feedId, name):
        return .run(
          operation: { send in
            let feedFolder = try await folderClient.patchFeedFolder(feedId, name)
            
            await send(.closeButtonTapped)
            await send(.delegate(.didUpdateFolder(feedId, feedFolder)))
          },
          catch: { error, send in
            print(error)
          }
        )
                
      case let .setFolderList(folderList):
        state.folderList = folderList
        return .none
        
      case let .setSelectedFolder(folder):
        state.initSelectedFolder = folder
        return .none
        
      case let .addFolderBottomSheet(.delegate(.didUpdate(folder))):
        var folderList = state.folderList
        folderList.append(folder)
        return .send(.setFolderList(folderList), animation: .default)
        
      default:
        return .none
      }
    }
  }
}
