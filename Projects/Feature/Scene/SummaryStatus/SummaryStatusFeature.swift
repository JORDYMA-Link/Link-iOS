//
//  SummaryStatusFeature.swift
//  Features
//
//  Created by kyuchul on 8/24/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Analytics
import Services
import Models

import ComposableArchitecture

@Reducer
public struct SummaryStatusFeature {
  @ObservableState
  public struct State: Equatable {
    var processingList: [LinkProcessingStatus] = []
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onAppear
    case closeButtonTapped
    case summaryStatusItemTapped(Int)
    case deleteButtonTapped(Int)
    
    // MARK: Inner Business Action
    case fetchLinkProcessing
    case deleteLinkProcessing(Int)
    
    // MARK: Inner SetState Action
    case setProcessingList([LinkProcessingStatus])
    case setDeleteProcessingLink(Int)
    
    // MARK: Delegate Action
    public enum Delegate {
      case summaryStatusItemTapped(Int)
    }
    
    case delegate(Delegate)
  }
  
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.linkClient) private var linkClient
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .send(.fetchLinkProcessing)
        
      case .closeButtonTapped:
        return .run { _ in await self.dismiss() }
        
      case let .summaryStatusItemTapped(feedId):
        summaryStatusItemTappedLog(feedId: feedId)
        
        return .run { send in await send(.delegate(.summaryStatusItemTapped(feedId)), animation: .default) }
        
        
      case let .deleteButtonTapped(feedId):
        return .send(.deleteLinkProcessing(feedId))
        
      case .fetchLinkProcessing:
        return .run(
          operation: { send in
            let linkProcessing = try await linkClient.getLinkProcessing()
            
            await send(.setProcessingList(linkProcessing.processingList), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .deleteLinkProcessing(feedId):
        return .run(
          operation: { send in
            _ = try await linkClient.deleteLinkDenySummary(feedId)
            
            await send(.setDeleteProcessingLink(feedId), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .setProcessingList(processingList):
        state.processingList = processingList
        return .none
        
      case let.setDeleteProcessingLink(feedId):
        if let index = state.processingList.firstIndex(where: { $0.feedId == feedId }) {
          state.processingList.remove(at: index)
        }
        
        return .none
        
      default:
        return .none
      }
    }
  }
}

// MARK: Analytics Log

extension SummaryStatusFeature {
  private func summaryStatusItemTappedLog(feedId: Int) {
    analyticsClient.logEvent(.init(name: .summarizedFeedClicked, screen: .summaring_feed, extraParameters: [.feedId: feedId]))
  }
}
