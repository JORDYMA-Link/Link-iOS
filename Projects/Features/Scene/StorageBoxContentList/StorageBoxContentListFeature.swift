//
//  StorageBoxContentListFeature.swift
//  Features
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

public enum FolderSortType: String, CaseIterable {
  /// 최신순
  case latestFirst = "최신순"
  /// 날짜순 (내림차순)
  case dateDescending = "날짜순"
  /// 가나다순 (알파벳순)
  case alphabetical = "가나다순"
}

@Reducer
public struct StorageBoxContentListFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    public var sortFolderBottomSheet: SortFolderBottomSheetFeature.State = .init()
    
    public var folderInput: Folder
    public var sortType: FolderSortType  = .latestFirst
    
    public init(folderInput: Folder) {
      self.folderInput = folderInput
    }
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case closeButtonTapped
    
    // MARK: Child Action
    case sortFolderBottomSheet(SortFolderBottomSheetFeature.Action)
  }
  
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.sortFolderBottomSheet, action: \.sortFolderBottomSheet) {
      SortFolderBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.folderInput):
        return .none
        
      case let .sortFolderBottomSheet(.sortCellTapped(type)):
        state.sortFolderBottomSheet.isSortFolderBottomSheetPresented = false
        if state.sortType == type {
          return .none
        } else {
          state.sortType = type
          return requestContentList(type)
        }
        
      case .closeButtonTapped:
         return .run { _ in await self.dismiss() }
    
      default:
        return .none
      }
    }
  }
}

extension StorageBoxContentListFeature {
  /// 해당 정렬 타입으로 API 콜
  private func requestContentList(_ sort: FolderSortType) -> Effect<Action> {
    return .run { send in
      print(sort)
    }
  }
}



