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
    var currentSheetDate = Date()
    var changeCurrentPageSheet = false
  }
  
  enum Action {
    case tappedDate(selectedDate: Date)
    case swipeCurrentPage(currentPage: Date)
    case changeCurrentPage(currentPage: Date)
    case tappedCurrentSheetButton
    case changeCurrentYear(dif: Int)
    case tappedCurrentSheetMonth(selectedMonth: Int)
  }
  
  //MARK: - Helper
  private let dayToSecond: TimeInterval = 86400 //FSCalendar의 Time이 하루 시차가 발생함. 수정을 위한 변수
  
  var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .tappedDate(selectedDate):
        state.selectedDate = selectedDate + dayToSecond
        print("connection Success\(state.selectedDate)")
        return .none
        
      case let .swipeCurrentPage(currentPage):
        state.currentPage = currentPage
        state.currentSheetDate = currentPage
        debugPrint(state.currentPage, state.currentSheetDate)
        return .none
        
      case .tappedCurrentSheetButton:
        state.changeCurrentPageSheet.toggle()
        return .none
        
      case let .changeCurrentPage(currentPage):
        state.currentSheetDate = currentPage
        debugPrint(state.currentPage, state.currentSheetDate)
        return .none
        
      case let .changeCurrentYear(dif):
        guard let targetDate = try? state.currentSheetDate.calculatingByAddingDate(byAdding: .year, value: dif), !targetDate.lessThan2024 else { return .none }
        state.currentSheetDate = targetDate
        debugPrint(state.currentPage, state.currentSheetDate)

        return .none
        
      case let .tappedCurrentSheetMonth(selectedMonth):
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: state.currentSheetDate)
        let year = components.year
        
        var newComponent = DateComponents()
        newComponent.year = year
        newComponent.month = selectedMonth
        
        if let date = calendar.date(from: newComponent) {
          state.currentPage = date
          state.changeCurrentPageSheet.toggle()
          state.currentSheetDate = date
        }
        debugPrint(state.currentPage, state.currentSheetDate)
        
        return .none
      }
    }
  }
}
