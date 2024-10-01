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
    //MARK: main State
    var isMenuBottomSheetPresented: Bool = false
    var calendarSearchData: SearchCalendar?
    
    //MARK: Child State
    var calendar = CalendarFeature.State()
    var article = CalendarArticleFeature.State()
    
    //MARK: FeedCard
    var selectedFeed: CalendarFeed?
  }
  
  //MARK: - Action
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    //MARK: Child Action
    case calendarAction(CalendarFeature.Action)
    case articleAction(CalendarArticleFeature.Action)
    
    //MARK: Business Logic
    case fetchCalendarData(yearMonth: String)
    case spreadEachReducer(_ searchCalendar: SearchCalendar)
    
    //MARK: User Action
    case tappedNaviBackButton
    case tappedSaveLinkButton
    
    //MARK: Delegate
    case delegate(CalendarViewFeature.Delegate)
  }
  
  public enum Delegate {
    case routeFeedDetail(Int)
  }

  //MARK: - Dependency
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.feedClient) private var feedClient
  
  //MARK: - Body
  public var body: some ReducerOf<Self> {
    Scope(state: \.calendar, action: \.calendarAction) {
      CalendarFeature()
    }
    Scope(state: \.article, action: \.articleAction) {
      CalendarArticleFeature()
    }
    
    Reduce { state, action in
      switch action {
        //MARK: User Aciton
      case .tappedNaviBackButton:
        return .run { _ in await self.dismiss() }
        
      case .tappedSaveLinkButton:
        return .run { _ in await self.dismiss() }
        
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
        guard let data = state.calendarSearchData?.existedFeedData[date]?.list else { return .none }
        
        state.article = CalendarArticleFeature.State(
          article: data
        )
        
        return .run { send in
          await send(.articleAction(.filteringFolder))
        }
        
      case let .articleAction(.delegate(.shouldPresentsBottomSheet(selectedFeed))):
        state.selectedFeed = selectedFeed
//        state.isMenuBottomSheetPresented = true
        return .none
        
      case let .articleAction(.delegate(.tappedFeedCard(feedID))):
        return .send(.delegate(.routeFeedDetail(feedID)))
        
      default:
        return .none
      }
    }
  }
}
