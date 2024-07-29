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
struct CalendarArticleFeature {
//  @ObservableState
  struct State {
    var categorySelectedIndex: Int = 0
  }
  
  enum Action {
    case changeCategorySelectedIndex(targetIndex: Int)
  }
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .changeCategorySelectedIndex(targetIndex):
        state.categorySelectedIndex = targetIndex
        debugPrint("changeCategorySelectedIndex")
        return .none
      }
    }
  }
  
}


