//
//  StorageBoxFeature.swift
//  Blink
//
//  Created by kyuchul on 5/24/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import CommonFeature
import Services
import Models

import ComposableArchitecture

@Reducer
public struct StorageBoxFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    var viewDidLoad: Bool = false
    var folderList: [Folder] = []
    var selectedStorageBoxMenuItem: Folder?
    var isAddFolder: Bool {
      return folderList.count < 200
    }
    
    var isMenuBottomSheetPresented: Bool = false
    var isDeleteFolderPresented: Bool = false
    
    var editFolderNameBottomSheet: EditFolderNameBottomSheetFeature.State = .init()
    var addFolderBottomSheet: AddFolderBottomSheetFeature.State = .init()
    
    @Presents var storageBoxContentList: StorageBoxContentListFeature.State?
    @Presents var searchKeyword: SearchKeywordFeature.State?
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case onAppear
    case searchBannerTapped
    case addStorageBoxTapped
    case storageBoxTapped(Folder)
    case storageBoxMenuTapped(Folder)
    
    // MARK: Inner Business Action
    case fetchFolderList
    case deleteFolder
    
    // MARK: Inner SetState Action
    case setFolderList([Folder])
    
    // MARK: Child Action
    case editFolderNameBottomSheet(EditFolderNameBottomSheetFeature.Action)
    case addFolderBottomSheet(AddFolderBottomSheetFeature.Action)
    case storageBoxContentList(PresentationAction<StorageBoxContentListFeature.Action>)
    case searchKeyword(PresentationAction<SearchKeywordFeature.Action>)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    
    // MARK: Present Action
    case menuBottomSheetPresented(Bool)
    case deleteFolderAlertPresented
  }
  
  @Dependency(\.folderClient) private var folderClient
  @Dependency(\.alertClient) private var alertClient
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet) {
      AddFolderBottomSheetFeature()
    }
    Scope(state: \.editFolderNameBottomSheet, action: \.editFolderNameBottomSheet) {
      EditFolderNameBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .onAppear:
        guard state.viewDidLoad == false else { return .none }
        state.viewDidLoad = true
        return .send(.fetchFolderList)
        
      case .searchBannerTapped:
        state.searchKeyword = .init()
        return .none
        
      case .addStorageBoxTapped:
        return .send(.addFolderBottomSheet(.addFolderTapped))
        
      case let .storageBoxTapped(folder):
        state.storageBoxContentList = .init(folderInput: folder)
        return .none
        
      case let .storageBoxMenuTapped(folder):
        state.selectedStorageBoxMenuItem = folder
        return .run { send in await send(.menuBottomSheetPresented(true)) }
        
      case .fetchFolderList:
        return .run(
          operation: { send in
            let folderList = try await folderClient.getFolders()
            
            await send(.setFolderList(folderList), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case .deleteFolder:
        guard let folder = state.selectedStorageBoxMenuItem else { return .none }
        return .run(
          operation: { send in
            _ = try await folderClient.deleteFolder(folder.id)
            
            await send(.fetchFolderList)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .setFolderList(folderList):
        state.folderList = folderList
        return .none
        
      case .addFolderBottomSheet(.delegate(.fetchFolderList)), .editFolderNameBottomSheet(.delegate(.fetchFolderList)):
        return .send(.fetchFolderList)
        
      case .menuBottomSheet(.editFolderNameItemTapped):
        guard let folder = state.selectedStorageBoxMenuItem else { return .none }
        state.isMenuBottomSheetPresented = false
        return .run { send in await send(.editFolderNameBottomSheet(.editFolderNameTapped(folder))) }
        
      case .menuBottomSheet(.deleteFolderItemTapped):
        state.isMenuBottomSheetPresented = false
        return .run { send in await send(.deleteFolderAlertPresented) }
        
      case let .menuBottomSheetPresented(isPresented):
        state.isMenuBottomSheetPresented = isPresented
        return .none
        
      case .deleteFolderAlertPresented:
        return .run { send in
          await alertClient.present(.init(
            title: "폴더 삭제",
            description: "폴더를 삭제하면 안에 있는 글이 모두 삭제 됩니다. 그래도 삭제하시겠습니까?",
            buttonType: .doubleButton(left: "취소", right: "확인"),
            rightButtonAction: { await send(.deleteFolder) }
          ))
        }
        
      default:
        return .none
      }
    }
    .ifLet(\.$storageBoxContentList, action: \.storageBoxContentList) {
      StorageBoxContentListFeature()
    }
    .ifLet(\.$searchKeyword, action: \.searchKeyword) {
      SearchKeywordFeature()
    }
  }
}
