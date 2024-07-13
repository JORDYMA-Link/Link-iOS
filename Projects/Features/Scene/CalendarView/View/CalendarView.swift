//
//  CalendarView.swift
//  Features
//
//  Created by 문정호 on 6/24/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

struct CalendarView: View {
  let store: StoreOf<CalendarFeature>
  private let months: [Month] = Month.allCases
  private let calendar = Calendar.current
  let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
  
    var body: some View {
      VStack(alignment: .leading) {
        
        Button{
          store.send(.tappedCurrentSheetButton)
        } label: {
          HStack {
            Text(store.state.currentPage.toStringYearMonth)
              .font(.semiBold(size: ._20))
            Image(systemName: "chevron.down")
          }
          .foregroundStyle(Color.bkColor(.gray900))
          .padding(EdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 0))
          
        }

        ZStack(alignment: .top){
          MigratedCalendarView(calendarStore: store)
          
          if store.state.changeCurrentPageSheet {
            selectionCurrentPageView
              .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
          }
        }
        
        
        Color.bkColor(.gray300)
        
      }
      .toolbar {
        
      }
    }
  
  @ViewBuilder
  var selectionCurrentPageView: some View {
    VStack {
      HStack {
        Spacer()
        
        Button {
          store.send(.changeCurrentYear(dif: -1))
        } label: {
          Image(systemName: "chevron.backward")
            .tint(.bkColor(.black))
        }
        
        Text(store.state.currentSheetDate.toString(formatter: "yyyy년"))
          .font(.regular(size: ._14))
        
        Button {
          store.send(.changeCurrentYear(dif: 1))
        } label: {
          Image(systemName: "chevron.right")
            .tint(.bkColor(.black))
        }
        
        Spacer()
        
        Button {
          store.send(.tappedCurrentSheetButton)
        } label: {
          Image(systemName: "xmark")
            .tint(.bkColor(.black))
        }
    
      }
      
      LazyVGrid(columns: columns, spacing: 20) {
        ForEach(months, id: \.self) { month in
          Text(month.toString)
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundStyle(searchSheetMonthColor(targetMonth: month.rawValue))
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
            .onTapGesture {
              store.send(.tappedCurrentSheetMonth(selectedMonth: month.rawValue))
            }
        }
      }
    }
    .padding(.all, 10)
    .background(Color.bkColor(.gray300))
    .clipShape(.rect(cornerRadius: 10))
    .shadow(radius: 10, x: 0, y: 8)
    
  }
  
  
}

extension CalendarView {
  private enum Month: Int, CaseIterable {
    case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
    
    var toString: String {
      return "\(self.rawValue)월"
      
    }
  }
  
  ///sheet의 컬러를 계산하여 반환한다.
  ///
  ///1. 먼저 현재 시간의 이전 이후를 판단하여 미래의 시간이라면 gray700(opacity 80프로)을 반환한다.
  ///2. 선택되어진 달인지 아닌지를 판단 후 일반 컬러 반환
  ///3. 아니라면 gray700를 반환
  private func searchSheetMonthColor(targetMonth: Int) -> Color {
    let currentDate = Date()
    
    let targetDate = calculatingCurrentSheetPageDate(month: targetMonth)
    
    let targetMonthTimeInterval = targetDate.timeIntervalSince1970
    
    guard targetMonthTimeInterval <= currentDate.timeIntervalSince1970 else {
      return Color.bkColor(.gray700).opacity(0.2)
    }
    
    
    let currentPageComponents = calendar.dateComponents([.year, .month], from: store.currentPage)
    let currentPageSheetComponents = calendar.dateComponents([.year, .month], from: targetDate)
    
    guard currentPageComponents == currentPageSheetComponents else {
      return Color.bkColor(.gray700)
    }
    
    return Color.bkColor(.gray900)

  }
  
  ///선택 가능한지 불가한지를 판단한다.
  private func yearIsPastOrCurrent(targetMonth: Int) -> Bool {
    let currentDate = Date()
    
    let targetDate = calculatingCurrentSheetPageDate(month: targetMonth)
    
    let targetMonthTimeInterval = targetDate.timeIntervalSince1970
    
    return  targetMonthTimeInterval <= currentDate.timeIntervalSince1970
  }
  
  ///현재 선택된 달인지 판단
//  private var isSelectedDate: Bool {
//    let currentComponents = calendar.component(.month, from: Date())
//    let currentSheetPageMonth = calendar.component(.month, from: store.currentSheetDate)
//    let targetDate = calculatingCurrentSheetPageDate(month: currentSheetPageMonth)
//    
//    return currentComponents == targetDate
//  }
//  
  
  //year와 month를 조합하여 새로운 Date 만드는 기능 Extension으로 빼서 CalendarFeature에서 공통으로 사용하면 좋을 듯 하나 일단 나중에
  /// 현재 SheetPage의 연도와 month를 조합하여 새로운 Date를 반환한다.
  private func calculatingCurrentSheetPageDate(month: Int) -> Date {
    let currentSheetDate = store.state.currentSheetDate
    let currentSheetYear = calendar.component(.year, from: currentSheetDate)
    
    return calendar.date(from: DateComponents.init(year: currentSheetYear, month: month)) ?? Date()
  }
  
}
#Preview {
  CalendarView(store: Store(initialState: CalendarFeature.State(), reducer: {
    CalendarFeature()
  }))
}
