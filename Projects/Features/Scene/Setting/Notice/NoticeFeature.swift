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
  public struct State {
    var noticeList: [NoticeModel] = []
    var page: Int = 0
    var size: Int = 10
  }
  
  public enum Action {
    //MARK: LifeCycle
    case fetchNotice
    case setNoticeData(_ noticeData: [NoticeModel])
  }
  
  @Dependency(\.noticeClient) private var noticeClient
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .fetchNotice:
        return .run { [page = state.page, size = state.size] send in
          let response = try await noticeClient.getNotice(page, size)
          return await send(.setNoticeData(response))
        }
        
      case let .setNoticeData(noticeData):
        state.noticeList.append(contentsOf: noticeData)
        state.page += 1
        return .none
      }
    }
  }
}


