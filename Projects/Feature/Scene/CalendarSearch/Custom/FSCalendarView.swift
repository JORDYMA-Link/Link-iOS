//
//  BKCalendarView.swift
//  Features
//
//  Created by 문정호 on 6/27/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI
import Combine

import ComposableArchitecture
import FSCalendar

///FSCalendar를 SwiftUI에서 사용할 수 있도록 UIViewRepresentable로 마이그레이션 진행한 View
///
///본 클래스는 TCA를 사용하는 것을 기준으로 만든 뷰로서 CalendarFeature의 Store를 구조체 생성시 추가해야합니다.
struct FSCalendarView: UIViewRepresentable {
  
  //MARK: - typealias
  typealias UIViewType = FSCalendar
  
  //MARK: - Properties
  private let calendar = FSCalendar()
  
  //MARK: - Binidng Properties
  @Binding var selectedDate: Date
  @Binding var currentPage: Date
  @Binding var eventDate: [Date]
  
  //MARK: - Delegate Closure Properties
  var didSelectDateAction: ((Date) -> Void)?
  var calendarCurrentPageDidChangeAction: ((Date) -> Void)?
  
  init(
    selectedDate: Binding<Date>,
    currentPage: Binding<Date>,
    eventDate: Binding<[Date]>,
    didSelectDateAction: ((Date) -> Void)? = nil,
    calendarCurrentPageDidChangeAction: ((Date) -> Void)? = nil
  ) {
    self._selectedDate = selectedDate
    self._currentPage = currentPage
    self._eventDate = eventDate
    self.didSelectDateAction = didSelectDateAction
    self.calendarCurrentPageDidChangeAction = calendarCurrentPageDidChangeAction
  }
  
  //MARK: - Implementation Protocol
  func makeUIView(context: Context) -> FSCalendar {
    configureAppearance()
    
    calendar.delegate = context.coordinator
    calendar.dataSource = context.coordinator
    
    configureDefaultSelectedDate()
    
    return calendar
  }
  
  func makeCoordinator() -> Coordinator {
    Coordinator(
      eventDate: $eventDate,
      didSelectDateAction: didSelectDateAction,
      calendarCurrentPageDidChangeAction: calendarCurrentPageDidChangeAction
    )
  }
  
  func updateUIView(_ uiView: FSCalendar, context: Context) {
    if currentPage != uiView.currentPage {
      uiView.setCurrentPage(currentPage, animated: true)
    }
    
    if !eventDate.isEmpty && (context.coordinator.lastEventDate != eventDate){
      context.coordinator.lastEventDate = eventDate
      
      uiView.collectionView.reloadData()
      
      if !context.coordinator.isFirstOnAppear {
        //FSCalendar 형식의 Date 형성
        var defaultDateComponents = Date().getDateComponents()
        defaultDateComponents.day = (defaultDateComponents.day ?? 2) // 혹시 모를 실패의 경우 1일을 select 하도록
        defaultDateComponents.hour = 9
        defaultDateComponents.minute = 0
        defaultDateComponents.second = 0
        
        if let defaultDate = Calendar.current.date(from: defaultDateComponents) {
          DispatchQueue.main.async {
            self.didSelectDateAction?(defaultDate)
          }
        }
        context.coordinator.isFirstOnAppear = true
      }
    }
  }
  
  //MARK: - Coordinator
  class Coordinator : NSObject, FSCalendarDelegate, FSCalendarDataSource {
    //MARK: - Coordinator Property : store
    
    @Binding var eventDate: [Date]
    var didSelectDateAction: ((Date) -> Void)?
    var calendarCurrentPageDidChangeAction: ((Date) -> Void)?
    
    var lastEventDate: [Date] //eventDate가 업데이트 되었을 때만 reloadData()를 할 수 있도록
    var isFirstOnAppear: Bool = false
    
    private let differenceTimeOfFSCalendar: TimeInterval = 60*60*9 //fscalendr의 로직 내부 Date와 실제 달력 날짜와의 차이: 달력 날짜와 9시간의 차이
    
    //MARK: - Initialization
    init(
      eventDate: Binding<[Date]>,
      lastEventDate: [Date] = [],
      didSelectDateAction: ((Date) -> Void)? = nil,
      calendarCurrentPageDidChangeAction: ((Date) -> Void)? = nil
    ) {
      self._eventDate = eventDate
      self.lastEventDate = []
      self.didSelectDateAction = didSelectDateAction
      self.calendarCurrentPageDidChangeAction = calendarCurrentPageDidChangeAction
    }
    //MARK: - Delegate
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
      return monthPosition == .current
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
      didSelectDateAction?(date+differenceTimeOfFSCalendar)
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
      calendarCurrentPageDidChangeAction?(calendar.currentPage)
    }
    
    //MARK: - DataSource
    func minimumDate(for calendar: FSCalendar) -> Date {
      if let date = Calendar.current.getDateFromComponents(year: 2024, month: 1, day: 1) {
        return date + differenceTimeOfFSCalendar
      } else {
        return calendar.minimumDate
      }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
      if eventDate.contains(date + differenceTimeOfFSCalendar) {
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
  
  private func configureDefaultSelectedDate() {
    let defaultSelectedDate = selectedDate - 32400
    
    self.calendar.select(defaultSelectedDate)
  }
}
