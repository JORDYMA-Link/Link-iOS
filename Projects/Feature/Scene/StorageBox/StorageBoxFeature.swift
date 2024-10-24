//
//  StorageBoxFeature.swift
//  Blink
//
//  Created by kyuchul on 5/24/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import DomainFolderInterface
import CommonFeature
import Services
import Models

import ComposableArchitecture

@Reducer
public struct StorageBoxFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    var folderList: [Folder] = []
    var selectedStorageBoxMenuItem: Folder?
    var isAddFolder: Bool {
      return folderList.count < 200
    }
    
    var isMenuBottomSheetPresented: Bool = false
    var isDeleteFolderPresented: Bool = false
        
    var editFolderNameBottomSheet: EditFolderNameBottomSheetFeature.State = .init()
    var addFolderBottomSheet: AddFolderBottomSheetFeature.State = .init()
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case onAppear
    case searchBannerTapped
    case searchBannerCalendarTapped
    case pullToRefresh
    case addStorageBoxTapped
    case storageBoxTapped(Folder)
    case storageBoxMenuTapped(Folder)
    
    // MARK: Inner Business Action
    case fetchFolderList
    case deleteFolder
    
    // MARK: Inner SetState Action
    case setFolderList([Folder])
    
    // MARK: Delegate Action
    public enum Delegate {
      case routeSearchKeyword
      case routeCalendar
      case routeStorageBoxFeedList(Folder)
    }
    
    case delegate(Delegate)
    
    // MARK: Child Action
    case editFolderNameBottomSheet(EditFolderNameBottomSheetFeature.Action)
    case addFolderBottomSheet(AddFolderBottomSheetFeature.Action)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    
    // MARK: Present Action
    case menuBottomSheetPresented(Bool)
    case deleteFolderAlertPresented
  }
  
  @Dependency(DomainFolderClient.self) private var folderClient
  @Dependency(\.alertClient) private var alertClient
  
  private enum DebounceId {
    case pullToRefresh
  }
  
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
        return .send(.fetchFolderList)
        
      case .searchBannerTapped:
        return .send(.delegate(.routeSearchKeyword))
        
      case .searchBannerCalendarTapped:
        return .send(.delegate(.routeCalendar))
        
      case .pullToRefresh:
        return .send(.fetchFolderList)
        
      case .addStorageBoxTapped:
        return .send(.addFolderBottomSheet(.addFolderTapped))
              
      case let .storageBoxTapped(folder):
        return .send(.delegate(.routeStorageBoxFeedList(folder)))
        
      case let .storageBoxMenuTapped(folder):
        state.selectedStorageBoxMenuItem = folder
        return .run { send in await send(.menuBottomSheetPresented(true)) }
        
      case .fetchFolderList:
        return .run(
          operation: { send in
            async let folderList = folderClient.getFolders()
            
            let list = try await folderList.map { Folder(id: $0.id, name: $0.name, feedCount: $0.feedCount) }
            
            await send(.setFolderList(list), animation: .default)
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
        
      case .addFolderBottomSheet(.delegate(.didUpdate)), .editFolderNameBottomSheet(.delegate(.fetchFolderList)):
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
  }
}
