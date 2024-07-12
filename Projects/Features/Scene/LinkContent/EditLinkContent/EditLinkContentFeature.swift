//
//  EditLinkContentFeature.swift
//  Features
//
//  Created by kyuchul on 7/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models
import Services

import ComposableArchitecture

@Reducer
public struct EditLinkContentFeature {
  @ObservableState
  public struct State: Equatable {
    var link: LinkCard
    
    public init(link: LinkCard) {
      self.link = link
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case closeButtonTapped
    
    // MARK: Inner Business Action
    
    // MARK: Inner SetState Action
    
    // MARK: Child Action
  }
  
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .closeButtonTapped:
         return .run { _ in await self.dismiss() }
                
      default:
        return .none
      }
    }
  }
}
