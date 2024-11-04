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
public struct CalendarFeature {
  @ObservableState
  public struct State: Equatable {
    var selectedDate = Date() + TimeInterval(TimeZone.current.secondsFromGMT())
    var existEventSelectedDate = false
    var currentPage = Date()
    var currentSheetDate = Date()
    var changeCurrentPageSheet = false
    var eventDate: [Date] = []
  }
  
  public enum Action {
    //MARK: Business Action
    case changeCurrentPage(currentPage: Date)
    case changeCurrentYear(dif: Int)
    case updatingEventDate(_ eventDate: [Date])
    
    //MARK: User Action
    case didSelectedDate(selectedDate: Date)
    case didSwipeCurrentPage(currentPage: Date)
    case currentSheetButtonTapped
    case currentSheetMonthTapped(selectedMonth: Int)
    
    //MARK: Delegate
    case delegate(CalendarFeatureDelegate)
  }
  
  public enum CalendarFeatureDelegate {
    case requestFetch(yearMonth: String)
    case changeSelectedDateFeedCard(date: Date)
  }
  //MARK: - Dependency
  @Dependency(\.mainQueue) private var mainQueue
  
  //MARK: - Helper
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case let .didSelectedDate(selectedDate):
        state.selectedDate = selectedDate
        
        state.existEventSelectedDate = (state.eventDate.contains(state.selectedDate))
        
        return .run { [state = state.selectedDate] send in
          await send(.delegate(.changeSelectedDateFeedCard(date: state)))
        }
        
      case let .didSwipeCurrentPage(currentPage):
        debugPrint("swipe", state.currentPage, state.currentSheetDate)
        return .run { send in
          await send(.changeCurrentPage(currentPage: currentPage))
        }
        
      case .currentSheetButtonTapped:
        state.changeCurrentPageSheet.toggle()
        return .none
        
      case let .changeCurrentPage(currentPage):
        state.currentPage = currentPage
        state.currentSheetDate = currentPage
        
        return .run { send in
          await send(.delegate(.requestFetch(yearMonth: currentPage.toString(formatter: "YYYY-MM"))))
        }
        .throttle(id: "changeCurrentPage", for: 0.5, scheduler: mainQueue, latest: false)
        
      case let .changeCurrentYear(dif):
        guard let targetDate = try? state.currentSheetDate.calculatingByAddingDate(byAdding: .year, value: dif), !lessThan2024(targetDate) else { return .none }
        state.currentSheetDate = targetDate

        return .none
        
      case let .currentSheetMonthTapped(selectedMonth):
        let calendar = Calendar.current
        let year = calendar.component(.year, from: state.currentSheetDate)
        
        guard let date = calendar.getDateFromComponents(year: year, month: selectedMonth) else { return .none }
        
        return .run { send in
          await send(.changeCurrentPage(currentPage: date))
          await send(.currentSheetButtonTapped)
        }
        
        //MARK: Delegate Action
      case let .updatingEventDate(eventDate):
        state.eventDate = eventDate
        return .none
        
      default:
        return .none
      }
    }
  }
  
  ///넘겨진 Date의 연도가 2024년 미만인지 판단합니다.
  ///
  ///우리 서비스는 2024년을 기준으로 그 이상만을 조회할 수 있습니다.
  ///파라미터로 넘겨진 날짜의 연도가 2024년 미만이라면 True를 반환합니다.
  private func lessThan2024(_ date: Date) -> Bool {
    let dateComponents = date.getDateComponents()
    return dateComponents.year ?? 2024 < 2024
  }
}
