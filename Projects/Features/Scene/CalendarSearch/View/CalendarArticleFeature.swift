//
//  CalendarArticleFeature.swift
//  Features
//
//  Created by 문정호 on 7/15/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct CalendarArticleFeature {
  @ObservableState
  public struct State: Equatable {
    var categorySelectedIndex: Int = 0
    var article: [CalendarFeed] = []
  }
  
  public enum Action {
    //MARK: - Business Action
    case updatingArticleState(_ newValue: [CalendarFeed]?)
    //MARK: - User Action
    case changeCategorySelectedIndex(targetIndex: Int)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .updatingArticleState(newArticle):
        state.article = newArticle ?? []
        return .none
      case let .changeCategorySelectedIndex(feedId):
        state.categorySelectedIndex = feedId
        return .none
      }
    }
  }
}


