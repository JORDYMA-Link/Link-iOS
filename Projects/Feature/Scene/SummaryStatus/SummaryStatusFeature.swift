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
    var webViewInfo: WebViewInfo = .init(flag: false, link: "")
    
    var isWebViewPresented: Bool = false
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onAppear
    case closeButtonTapped
    case closeBKWebView
    case openSurveyFormButtonTapped(String)
    case summaryStatusItemTapped(Int)
    case deleteButtonTapped(Int)
    
    // MARK: Inner Business Action
    case fetchLinkProcessing
    case deleteLinkProcessing(Int)
    case fetchWebViewInfo
    
    // MARK: Inner SetState Action
    case setProcessingList([LinkProcessingStatus])
    case setDeleteProcessingLink(Int)
    case setWebViewInfo(WebViewInfo)
    
    // MARK: Delegate Action
    public enum Delegate {
      case summaryStatusItemTapped(Int)
    }
    
    case delegate(Delegate)
    
    // MARK: Present Action
    case webViewPresented(Bool)
  }
  
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(URLOpenHandlerClient.self) private var urlOpenHandlerClient
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.linkClient) private var linkClient
  @Dependency(\.noticeClient) private var noticeClient
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
            await send(.fetchLinkProcessing)
            await send(.fetchWebViewInfo)
        }
        
      case .closeButtonTapped:
        return .run { _ in await self.dismiss() }
        
      case .closeBKWebView:
        return .send(.webViewPresented(false))
        
      case let .openSurveyFormButtonTapped(surveyFormURL):
        return .run { send in
          await urlOpenHandlerClient.openURL(urlType: .custom(surveyFormURL))
        }
        
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
          operation: { [state] send in
            _ = try await linkClient.deleteLinkDenySummary(feedId)
            
            await send(.setDeleteProcessingLink(feedId), animation: .default)
            
            if state.webViewInfo.flag {
              await send(.webViewPresented(true))
            }
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case .fetchWebViewInfo:
        return .run(
          operation: { send in
            let info = try await noticeClient.getWebViewInfo()
            
            await send(.setWebViewInfo(info))
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
        
      case let .setWebViewInfo(info):
        guard info.link.isHTTPURL else {
          return .none
        }
        
        state.webViewInfo = info
        return .none
        
      case let .webViewPresented(isPresented):
        state.isWebViewPresented = isPresented
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
