//
//  SortFolderBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 6/22/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct SortFolderBottomSheetFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    public var isSortFolderBottomSheetPresented: Bool = false
    public var inputSortType: FolderSortType?
    public init() {}
  }
  
  public enum Action: Equatable {
    case sortFolderTapped(FolderSortType)
    case sortCellTapped(FolderSortType)
    case closeButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .sortFolderTapped(sortType):
        state.inputSortType = sortType
        state.isSortFolderBottomSheetPresented = true
        return .none
        
      case .closeButtonTapped:
        state.isSortFolderBottomSheetPresented = false
        return .none
        
      default:
        return .none
      }
    }
  }
}
