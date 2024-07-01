//
//  BKCalendarView.swift
//  Features
//
//  Created by 문정호 on 6/27/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI
import FSCalendar
import ComposableArchitecture

struct BKCalendarView: UIViewRepresentable {
  
  //MARK: - typealias
  typealias UIViewType = FSCalendar
  
  //MARK: - Properties
  private let calendar = FSCalendar()
  private let customHeaderView: CustomCalendarHeaderView
  
  let calendarStore: StoreOf<CalendarFeature> // store은 클래스지만 어차피 구조체가 계속 업데이트 되어 바뀌는 구조일 것 이기 때문에 약한 참조로 선언할 필요가 없을 듯 함.
  
  init(calendarStore: StoreOf<CalendarFeature>) {
    self.calendarStore = calendarStore
    self.customHeaderView = CustomCalendarHeaderView(frame: .zero, calendar: self.calendar)
  }
  
  //MARK: - Implementation Protocol
  func makeUIView(context: Context) -> FSCalendar {
    calendar.calendarHeaderView.isHidden = true
    
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.scope = .month
    
    calendar.delegate = context.coordinator
    calendar.dataSource = context.coordinator
    return calendar
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(calendarStore: self.calendarStore)
  }
  
  func updateUIView(_ uiView: FSCalendar, context: Context) {
    customHeaderView.setCurrentPageTitle(currentPage: uiView.currentPage.toStringYearMonth)
  }
  
  //MARK: - Coordinator
  class Coordinator : NSObject, FSCalendarDelegate, FSCalendarDataSource {
    //MARK: - store
    let calendarStore: StoreOf<CalendarFeature>
    
    //MARK: - Initialization
    init(calendarStore: StoreOf<CalendarFeature>) {
      self.calendarStore = calendarStore
    }
    
    //MARK: - Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
      calendarStore.send(.tappedDate(selectedDate: date))
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
      guard let customHeaderView = calendar.calendarHeaderView as? CustomCalendarHeaderView else { return }
      customHeaderView.setCurrentPageTitle(currentPage: calendar.currentPage.toStringYearMonth)
    }
    //MARK: - DataSource
    
  }
}




