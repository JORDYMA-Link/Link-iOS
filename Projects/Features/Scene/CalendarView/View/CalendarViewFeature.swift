//
//  IntegratedCalendarFeature.swift
//  Features
//
//  Created by 문정호 on 7/15/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct CalendarViewFeature {
  @ObservableState
  public struct State: Equatable {
    var calendar = CalendarFeature.State()
    var article = CalendarArticleFeature.State()
  }
  
  public enum Action {
    case calendarAction(CalendarFeature.Action)
    case articleAction(CalendarArticleFeature.Action)
  }

  public var body: some ReducerOf<Self> {
    Scope(state: \.calendar, action: \.calendarAction) {
      CalendarFeature()
    }
    Scope(state: \.article, action: \.articleAction) {
      CalendarArticleFeature()
    }
    
    Reduce { state, action in
      return .none
    }
  }
}
