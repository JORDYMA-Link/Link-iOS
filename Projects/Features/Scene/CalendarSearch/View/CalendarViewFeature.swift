//
//  IntegratedCalendarFeature.swift
//  Features
//
//  Created by 문정호 on 7/15/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct CalendarViewFeature {
  //MARK: - State
  @ObservableState
  public struct State: Equatable {
    //MARK: Child State
    var calendar = CalendarFeature.State()
    var article = CalendarArticleFeature.State()
    
    var calendarSearchData: SearchCalendar?
  }
  
  //MARK: - Action
  public enum Action {
    //MARK: Child Action
    case calendarAction(CalendarFeature.Action)
    case articleAction(CalendarArticleFeature.Action)
    
    //MARK: Business Logic
    case fetchCalendarData(yearMonth: String)
    case spreadEachReducer(_ searchCalendar: SearchCalendar)
  }

  //MARK: - Dependency
  @Dependency(\.feedClient) private var feedClient
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.calendar, action: \.calendarAction) {
      CalendarFeature()
    }
    Scope(state: \.article, action: \.articleAction) {
      CalendarArticleFeature()
    }
    
    Reduce { state, action in
      switch action {
      case let .fetchCalendarData(yearMonth):
        return .run { send in
          let responseDTO = try await feedClient.getFeedCalendarSearch(yearMonth)
          
          await send(.spreadEachReducer(responseDTO))
        }
        
      //MARK: Business Action
      case let .spreadEachReducer(searchCalendar):
        state.calendarSearchData = searchCalendar
        return .run { send in
          await send(.calendarAction(.updatingEventDate(searchCalendar.existedFeedData.map{ $0.key })))
        }
        
      //MARK: Delegate Action
      case let .calendarAction(.delegate(.requestFetch(yearMonth))):
        return .run { send in
          await send(.fetchCalendarData(yearMonth: yearMonth))
        }
        
      case let .calendarAction(.delegate(.changeSelectedDateFeedCard(date))):
        guard let data = state.calendarSearchData else { return .none }
        
        return .run { [state = data.existedFeedData] send in
          await send(.articleAction(.updatingArticleState(state[date]?.list)))
        }
        
      default:
        return .none
      }
    }
  }
}
