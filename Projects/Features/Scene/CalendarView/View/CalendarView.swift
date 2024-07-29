//
//  CalendarView.swift
//  Features
//
//  Created by 문정호 on 6/24/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import SwipeActions
import CommonFeature

struct CalendarView: View {
//  let store: StoreOf<CalendarFeature>
  let store: StoreOf<IntegratedCalendarFeature>
  
  @StateObject private var scrollViewDelegate = HomeScrollViewDelegate()
  
  private let months: [Month] = Month.allCases
  private let calendar = Calendar.current
  let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
  
  var body: some View {
    VStack(alignment: .leading) {
      
      Button{
        store.send(.calendarAction(.tappedCurrentSheetButton))
      } label: {
        HStack {
          Text(store.state.calendar.currentPage.toStringYearMonth)
            .font(.semiBold(size: ._20))
          Image(systemName: "chevron.down")
        }
        .foregroundStyle(Color.bkColor(.gray900))
        .padding(EdgeInsets(top: 0, leading: 20, bottom: 8, trailing: 0))
        
      }
      .padding(.leading, 20)
      
      ZStack(alignment: .top){
        MigratedCalendarView(calendarStore: store.scope(state: \.calendar, action: \.calendarAction))
        
        if store.calendar.changeCurrentPageSheet {
          selectionCurrentPageView
            .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
        }
      }
      .padding(.horizontal, 20)
      
      ZStack{
        Color.bkColor(.gray300)
          .ignoresSafeArea()
        
        if store.state.calendar.existEventSelectedDate { // contents에 대한 조건식
          GeometryReader { geometry in
            VStack{
              makeCategorySectionHeader
              
              ScrollView(.horizontal) {
                LazyHStack(spacing: 4) {
                  Section {
                    ForEach(1...10, id: \.self) { count in
                      BKCardCell(width: geometry.size.width - 32, sourceTitle: "브런치", sourceImage: CommonFeature.Images.graphicBell, saveAction: {}, menuAction: {}, title: "방문자 상위 50위 생성형 AI 웹 서비스 분석", description: "꽁꽁얼어붙은", keyword: ["Design System", "디자인", "UI/UX"], isUncategorized: false, recommendedFolders: nil, recommendedFolderAction: {}, addFolderAction: {})
                    }
                  }
                  .padding(.init(top: 0, leading: 16, bottom: 60, trailing: 16))
                }
              }
              .scrollIndicators(.hidden)
              
            }
            
          }
        } else {
          noneContentsView
        }
      }
      
        
    }
      
      .toolbar {
        
      }
    }
  
  //MARK: - ViewBuilder
  @ViewBuilder
  var selectionCurrentPageView: some View {
    VStack {
      HStack {
        Spacer()
        
        Button {
          store.send(.calendarAction(.changeCurrentYear(dif: -1)))
        } label: {
          Image(systemName: "chevron.backward")
            .tint(.bkColor(.black))
        }
        
        Text(store.calendar.currentSheetDate.toString(formatter: "yyyy년"))
          .font(.regular(size: ._14))
        
        Button {
          store.send(.calendarAction(.changeCurrentYear(dif: 1)))
        } label: {
          Image(systemName: "chevron.right")
            .tint(.bkColor(.black))
        }
        
        Spacer()
        
        Button {
          store.send(.calendarAction(.tappedCurrentSheetButton))
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
              store.send(.calendarAction(.tappedCurrentSheetMonth(selectedMonth: month.rawValue)))
            }
        }
      }
    }
    .padding(.all, 10)
    .background(Color.bkColor(.gray300))
    .clipShape(.rect(cornerRadius: 10))
    .shadow(radius: 10, x: 0, y: 8)
    
  }
  
  @ViewBuilder
  var noneContentsView : some View {
    VStack {
      Image(uiImage: CommonFeature.Images.graphicFolderUIImage)
      Text("저장된 콘텐츠가 없습니다")
        .font(.semiBold(size: ._15))
        .foregroundStyle(Color.bkColor(.gray900))
        .padding(.bottom, 4)
      
      Text("해당 날짜에 저장된 콘텐츠가 없습니다")
        .font(.regular(size: ._12))
        .foregroundStyle(Color.bkColor(.gray700))
        .padding(.bottom, 16)
      
      Button {
        
      } label: {
        Text("저장하러 가기")
          .font(.semiBold(size: ._13))
          .foregroundStyle(Color.bkColor(.gray900))
      }
      .frame(width: 134, height: 32)
      .background(Color.bkColor(.gray500))
      .clipShape(.rect(cornerRadius: 6))
      
    }
  }
  
//  @ViewBuilder
//  private func makeCategorySectionHeader(selectedIndex: Int) -> some View {
//      let categories = ["중요", "미분류"]
//  
//      ScrollView(.horizontal) {
//          HStack(spacing: 8) {
//              ForEach(categories.indices, id: \.self) { index in
//                
//                let isSelectedIndex = (selectedIndex == index)
//                
//                  Text(categories[index])
//                      .font(isSelectedIndex ? .semiBold(size: ._14) : .regular(size: ._14))
//                      .foregroundColor(isSelectedIndex ? Color.white : Color.black)
//                      .padding(.vertical, 10)
//                      .padding(.horizontal, 14)
//                      .background(
//                          RoundedRectangle(cornerRadius: 100)
//                              .fill(isSelectedIndex ? Color.black : Color.white)
//                              .overlay(
//                                  RoundedRectangle(cornerRadius: 100)
//                                      .stroke(isSelectedIndex ? Color.clear : Color.bkColor(.gray500), lineWidth: 1)
//                              )
//                          
//                      )
//                      .onTapGesture {
//                        debugPrint("selected")
//                        store.send(.articleAction(.changeCategorySelectedIndex(targetIndex: index)))
//                        debugPrint(store.state.article.categorySelectedIndex)
//                      }
//              }
//          }
//          .padding(.leading, 16)
//      }
//      .scrollDisabled(true)
//      .padding(EdgeInsets(top: 20, leading: 0, bottom: 36, trailing: 0))
//  }

  var makeCategorySectionHeader: some View {
      let categories = ["중요", "미분류"]
  
      return ScrollView(.horizontal) {
          HStack(spacing: 8) {
              ForEach(categories.indices, id: \.self) { index in
                
                let isSelectedIndex = (store.article.categorySelectedIndex == index)
                
                  Text(categories[index])
                      .font(isSelectedIndex ? .semiBold(size: ._14) : .regular(size: ._14))
                      .foregroundColor(isSelectedIndex ? Color.white : Color.black)
                      .padding(.vertical, 10)
                      .padding(.horizontal, 14)
                      .background(
                          RoundedRectangle(cornerRadius: 100)
                              .fill(isSelectedIndex ? Color.black : Color.white)
                              .overlay(
                                  RoundedRectangle(cornerRadius: 100)
                                      .stroke(isSelectedIndex ? Color.clear : Color.bkColor(.gray500), lineWidth: 1)
                              )
                          
                      )
                      .onTapGesture {
                        debugPrint("selected")
                        store.send(.articleAction(.changeCategorySelectedIndex(targetIndex: index)))
                        debugPrint(store.state.article.categorySelectedIndex)
                      }
              }
          }
          .padding(.leading, 16)
      }
      .scrollDisabled(true)
      .padding(EdgeInsets(top: 20, leading: 0, bottom: 36, trailing: 0))
  }
  
  
  
}

//MARK: - Calculating Date Part
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
    
    
    let currentPageComponents = calendar.dateComponents([.year, .month], from: store.calendar.currentPage)
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
  

  
  //year와 month를 조합하여 새로운 Date 만드는 기능 Extension으로 빼서 CalendarFeature에서 공통으로 사용하면 좋을 듯 하나 일단 나중에
  /// 현재 SheetPage의 연도와 month를 조합하여 새로운 Date를 반환한다.
  private func calculatingCurrentSheetPageDate(month: Int) -> Date {
    let currentSheetDate = store.calendar.currentSheetDate
    let currentSheetYear = calendar.component(.year, from: currentSheetDate)
    
    return calendar.date(from: DateComponents.init(year: currentSheetYear, month: month)) ?? Date()
  }
  
  private struct CategorySectionHeaderPreferenceKey: PreferenceKey {
      static var defaultValue: CGFloat = .zero
      
      static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
          value = max(value, nextValue())
      }
  }
  
}

#Preview {
  CalendarView(store: Store(initialState: IntegratedCalendarFeature.State(), reducer: {
    IntegratedCalendarFeature()
  }))
}
