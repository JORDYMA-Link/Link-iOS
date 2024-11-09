//
//  NoticeFeature.swift
//  Features
//
//  Created by 문정호 on 8/26/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import Models

import ComposableArchitecture

@Reducer
public struct NoticeFeature {
  @ObservableState
  public struct State: Equatable {
    var expandedNoticeID: UUID?
    var noticeList: [NoticeModel] = []
    var nextPage: Int = 0
    var size: Int = 10
    var existNotFetchedNotice: Bool = true
  }
  
  public enum Action {
    //MARK: LifeCycle
    case fetchNotice
    case setNoticeData(_ noticeData: [NoticeModel])
    case expanding(target: UUID?)
    
    //MARK: Business Logic
    case isExistNextPage(Int)
    
    //MARK: User Action
    case tappedNaviBackButton
  }
  
  //MARK: - Dependency
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.noticeClient) private var noticeClient
  
  //MARK: - Body
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .tappedNaviBackButton:
        return .run { _ in await self.dismiss() }
        
      case .fetchNotice:
        guard state.existNotFetchedNotice else { return .none }
        
        return .run { [page = state.nextPage, size = state.size] send in
          let response = try await noticeClient.getNotice(page, size)
          await send(.setNoticeData(response))
          await send(.isExistNextPage(response.count))
        }
        
      case let .setNoticeData(noticeData):
        if !noticeData.isEmpty {
          state.noticeList.append(contentsOf: noticeData)
          state.nextPage += 1
        }
        return .none
        
      case let .isExistNextPage(fetchedNoticeCount):
        let isExistNextPage = (fetchedNoticeCount >= state.size)
        state.existNotFetchedNotice = isExistNextPage
        return .none
        
      case let .expanding(target):
        state.expandedNoticeID = target
        return .none
      }
    }
  }
}


