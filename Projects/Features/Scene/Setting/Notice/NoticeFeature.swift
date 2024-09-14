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
    var page: Int = 0
    var size: Int = 10
  }
  
  public enum Action {
    //MARK: LifeCycle
    case fetchNotice
    case setNoticeData(_ noticeData: [NoticeModel])
    case expanding(target: UUID?)
    
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
        return .run { [page = state.page, size = state.size] send in
          let response = try await noticeClient.getNotice(page, size)
          return await send(.setNoticeData(response))
        }
        
      case let .setNoticeData(noticeData):
        state.noticeList.append(contentsOf: noticeData)
        state.page += 1
        return .none
        
      case let .expanding(target):
        state.expandedNoticeID = target
        return .none
      }
    }
  }
}


