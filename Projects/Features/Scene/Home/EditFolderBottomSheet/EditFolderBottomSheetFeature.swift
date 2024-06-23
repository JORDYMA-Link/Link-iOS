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
    public var isEditFolderBottomSheetPresented: Bool = false
    
    public var postLinkId: String?
    
    public var folderList: [Folder] = []
    public var seletedFolder: Folder?
    
    public init() {}
  }
  
  public enum Action: Equatable {
    // MARK: User Action
    case editFolderTapped(String)
    case folderCellTapped(Folder)
    case closeButtonTapped
    
    // MARK: Inner Business Action
    case _onTask
    
    // MARK: Inner SetState Action
    case _setFolderList([Folder])
    case _selectedFolder(Folder)
    
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .editFolderTapped(id):
        state.postLinkId = id
        state.isEditFolderBottomSheetPresented = true
        return .none
        
      case .closeButtonTapped:
        state.isEditFolderBottomSheetPresented = false
        return .none
        
      case ._onTask:
        guard let id = state.postLinkId else { return .none }
        return requestFolderList(postLinkId: id)
        
      case let ._setFolderList(folderList):
        state.folderList = folderList
        return .none
        
      case let ._selectedFolder(folder):
        state.seletedFolder = folder
        return .none
        
      default:
        return .none
      }
    }
  }
}

extension EditFolderBottomSheetFeature {
  /// 폴더 리스트 API 콜
  private func requestFolderList(postLinkId: String) -> Effect<Action> {
    .run { send in
      do {
        // API 연결 이전 테스트 -> postLinkId로 API 콜하는 상상 로직..
        let dummyFolderList = [
          Folder(title: "건강", count: 89),
          Folder(title: "기획", count: 89),
          Folder(title: "비트코인", count: 89),
          Folder(title: "업비트", count: 89),
          Folder(title: "빗썸", count: 89),
          Folder(title: "코인원", count: 89)
        ]
        await send(._setFolderList(dummyFolderList))
        
        if let firstFolder = dummyFolderList.first {
          await send(._selectedFolder(firstFolder))
        }
      } catch {
        print(error)
      }
    }
  }
}
