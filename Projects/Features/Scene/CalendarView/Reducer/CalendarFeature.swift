//
//  CalendarFeature.swift
//  Features
//
//  Created by 문정호 on 6/27/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
struct CalendarFeature {
  @ObservableState
  struct State {
    var selectedDate = Date()
    var currentPage = Date()
  }
  
  enum Action {
    case tappedDate(selectedDate: Date)
    case swipeCurrentPage(currentPage: Date)
  }
  
  //MARK: - Helper
  private let dayToSecond : TimeInterval = 86400 //FSCalendar의 Time이 하루 시차가 발생함. 수정을 위한 변수
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .tappedDate(selectedDate):
        state.selectedDate = selectedDate + dayToSecond
        print("connection Success\(state.selectedDate)")
        return .none
        
      case let .swipeCurrentPage(currentPage):
        state.currentPage = currentPage
        print(state.currentPage)
        return .none
      }
    }
  }
}
