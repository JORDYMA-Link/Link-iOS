//
//  StorageBoxMenuBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 6/18/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

public enum MenuType {
  case editFolderName
  case deleteFoler
}

@Reducer
public struct StorageBoxMenuBottomSheetFeature: Reducer {
  @ObservableState
  public struct State: Equatable {
    public var isMenuBottomSheetPresented: Bool = false
    public var seletedFolder: Folder?
    public init() {}
  }
  
  public enum Action: Equatable {
    case storageBoxMenuTapped(Folder)
    case menuTapped(MenuType)
    case closeButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .storageBoxMenuTapped(folder):
        state.seletedFolder = folder
        state.isMenuBottomSheetPresented = true
        return .none
        
      case .closeButtonTapped:
        state.isMenuBottomSheetPresented = false
        return .none
        
      default:
        return .none
      }
    }
  }
}
