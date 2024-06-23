//
//  LinkPostMenuBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 6/23/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

public enum LinkPostMenuType {
  case editLinkPost
  case deleteLinkPost
}

@Reducer
public struct LinkPostMenuBottomSheetFeature {
  @ObservableState
  public struct State: Equatable {
    public var isMenuBottomSheetPresented: Bool = false
    public var seletedLinkPost: LinkCard?
    public init() {}
  }
  
  public enum Action: Equatable {
    case linkPostMenuTapped(LinkCard)
    case menuTapped(LinkPostMenuType)
    case closeButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .linkPostMenuTapped(linkPost):
        state.seletedLinkPost = linkPost
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
