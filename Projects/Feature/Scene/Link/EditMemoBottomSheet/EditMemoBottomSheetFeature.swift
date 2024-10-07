//
//  EditMemoBottomSheetFeature.swift
//  Features
//
//  Created by kyuchul on 7/11/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Services
import Models

import ComposableArchitecture

@Reducer
public struct EditMemoBottomSheetFeature {
  @ObservableState
  public struct State: Equatable {
    var feedId: Int?
    var memo = ""
    var initMemo: String?
    var isValidation: Bool = true
    
    var isEditMemoBottomSheetPresented: Bool = false
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    // MARK: User Action
    case editMemoTapped(Int, String)
    case confirmButtonTapped
    case closeButtonTapped
    
    // MARK: Inner Business Action
    case postFeedMemo(Int, String)
    case dismiss
    
    // MARK: Inner SetState Action
    case setValidation(Bool)
    
    // MARK: Delegate Action
    public enum Delegate {
      case didUpdateMemo(Feed)
    }
    case delegate(Delegate)
  }
  
  @Dependency(\.feedClient) private var feedClient
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.memo):
        guard state.memo.count <= 1000 else { return .send(.setValidation(false)) }
        return .send(.setValidation(true))
        
      case let .editMemoTapped(feedId, memo):
        state.feedId = feedId
        state.memo = memo
        state.initMemo = memo
        state.isEditMemoBottomSheetPresented = true
        return .none
        
      case .confirmButtonTapped:
        guard state.memo != state.initMemo else { return .send(.dismiss) }
        return .send(.postFeedMemo(state.feedId ?? 0, state.memo))
        
      case .closeButtonTapped:
        return .send(.dismiss)
        
      case let .postFeedMemo(feedId, memo):
        return .run(
          operation: { send in
            let feed = try await feedClient.postFeedMemo(feedId, memo)
            
            await send(.delegate(.didUpdateMemo(feed)))
            await send(.dismiss)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .setValidation(isValidation):
        state.isValidation = isValidation
        return .none
        
      case .dismiss:
        state.feedId = nil
        state.memo = .init()
        state.initMemo = nil
        state.isEditMemoBottomSheetPresented = false
        return .none
                
      default:
        return .none
      }
    }
  }
}
