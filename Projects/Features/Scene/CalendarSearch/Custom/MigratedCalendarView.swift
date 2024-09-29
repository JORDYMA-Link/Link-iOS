//
//  BKCalendarView.swift
//  Features
//
//  Created by 문정호 on 6/27/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import FSCalendar

///FSCalendar를 SwiftUI에서 사용할 수 있도록 UIViewRepresentable로 마이그레이션 진행한 View
///
///본 클래스는 TCA를 사용하는 것을 기준으로 만든 뷰로서 CalendarFeature의 Store를 구조체 생성시 추가해야합니다.
struct MigratedCalendarView: UIViewRepresentable {
  
  //MARK: - typealias
  typealias UIViewType = FSCalendar
  
  //MARK: - Properties
  private let calendar = FSCalendar()
  
  let calendarStore: StoreOf<CalendarFeature> // store은 클래스지만 어차피 구조체가 계속 업데이트 되어 바뀌는 구조일 것 이기 때문에 약한 참조로 선언할 필요가 없을 듯 함.
  
  init(calendarStore: StoreOf<CalendarFeature>) {
    self.calendarStore = calendarStore
  }
  
  //MARK: - Implementation Protocol
  func makeUIView(context: Context) -> FSCalendar {
    configureAppearance()
    
    calendar.delegate = context.coordinator
    calendar.dataSource = context.coordinator
    
    return calendar
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(calendarStore: self.calendarStore)
  }
  
  func updateUIView(_ uiView: FSCalendar, context: Context) {
    if calendarStore.state.currentPage + 32400 != uiView.currentPage {
      uiView.setCurrentPage(calendarStore.state.currentPage, animated: true)
    }
  }
  
  //MARK: - Coordinator
  class Coordinator : NSObject, FSCalendarDelegate, FSCalendarDataSource {
    //MARK: - Coordinator Property : store
    let calendarStore: StoreOf<CalendarFeature>
    
    //MARK: - Initialization
    init(calendarStore: StoreOf<CalendarFeature>) {
      self.calendarStore = calendarStore
    }
    
    //MARK: - Delegate
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
      return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
      calendarStore.send(.tappedDate(selectedDate: date))
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
      calendarStore.send(.swipeCurrentPage(currentPage: calendar.currentPage))
    }
    //MARK: - DataSource
    func minimumDate(for calendar: FSCalendar) -> Date {
      if let date = Calendar.current.getDateFromComponents(year: 2024, month: 1, day: 1) {
        return date + 32400
      } else {
        return calendar.minimumDate
      }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
      if calendarStore.state.eventDate.contains(date + 32400) {
        return 1
      } else {
        return 0
      }
    }
  }
  
  //MARK: - Helper
  private func configureAppearance() {
    //configure Header
    calendar.calendarHeaderView.isHidden = true
    calendar.headerHeight = 0
  
    // Calendar Appearance
    calendar.appearance.weekdayTextColor = .bkColor(.gray600)
    calendar.appearance.todayColor = .bkColor(.main100)
    calendar.appearance.titleTodayColor = .bkColor(.gray900)
    calendar.appearance.selectionColor = .bkColor(.main300)
    calendar.appearance.titleSelectionColor = .bkColor(.white)
    calendar.appearance.titleFont = .regular(size: ._18)
    calendar.appearance.eventDefaultColor = .bkColor(.main300)
    
    
    calendar.locale = Locale(identifier: "ko_KR")
    calendar.scope = .month
  }
}
