//
//  CalendarArticleFeature.swift
//  Features
//
//  Created by 문정호 on 7/15/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct CalendarArticleFeature {
  @ObservableState
  public struct State: Equatable {
    var categorySelectedIndex: Int = 0
  }
  
  public enum Action {
    case changeCategorySelectedIndex(targetIndex: Int)
  }
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .changeCategorySelectedIndex(targetIndex):
        state.categorySelectedIndex = targetIndex
        return .none
      }
    }
  }
}


