//
//  CalendarView.swift
//  Features
//
//  Created by 문정호 on 6/24/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

public struct CalendarSearchView: View {
  @Perception.Bindable var store: StoreOf<CalendarSearchFeature>
  
  private let months: [Month] = Month.allCases
  private let calendar = Calendar.current
  private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
  
  public var body: some View {
    WithPerceptionTracking {
      VStack {
        makeBKNavigationView(
          leadingType: .dismiss("저장기록", { store.send(.naviBackButtonTapped) }),
          trailingType: .none
        )
        .padding(.leading, 16)
        
        HStack {
          Button{
            store.send(.calendarAction(.currentSheetButtonTapped))
          } label: {
            HStack {
              Text(store.state.calendar.currentPage.toString(formatter: "YYYY. MM"))
                .font(.semiBold(size: ._20))
              CommonFeature.Images.icoChevronDown
            }
            .foregroundStyle(Color.bkColor(.gray900))
          }
          .frame(alignment: .leading)
          .padding(.leading, 20)
          
          Spacer()
        }
        
        ZStack(alignment: .top){
          FSCalendarView(
            selectedDate: $store.calendar.selectedDate,
            currentPage: $store.calendar.currentPage,
            eventDate: $store.calendar.eventDate,
            didSelectDateAction: { store.send(.calendarAction(.didSelectedDate(selectedDate: $0))) },
            calendarCurrentPageDidChangeAction:{ store.send(.calendarAction(.didSwipeCurrentPage(currentPage: $0)))}
          )
          .padding(.horizontal, 5)
          
          if store.calendar.changeCurrentPageSheet {
            selectionCurrentPageView
              .padding(.horizontal, 20)
          }
        }
        
        ZStack {
          Color.bkColor(.gray300)
            .ignoresSafeArea()
          
          if store.state.calendar.existEventSelectedDate { // contents에 대한 조건식
            GeometryReader { geometry in
              WithPerceptionTracking {
                VStack{
                  makeCategorySectionHeader
                  
                  ScrollView(.horizontal) {
                    LazyHStack(spacing: 4) {
                      WithPerceptionTracking {
                        Section {
                          cardCellView
                        }// Section
                        .padding(.init(top: 0, leading: 16, bottom: 60, trailing: 0))
                      }
                    }// LazyHStack
                  }// ScrollView
                  .scrollIndicators(.hidden)
                }// VStack
              }
            }// GeometryReader
          } else {
            noneContentsView
          }// else
        }// ZStack
      } //VStack
      .navigationBarBackButtonHidden(true)
      .onAppear(perform: {
        store.send(.fetchCalendarData(yearMonth: store.calendar.currentPage.toString(formatter: "YYYY-MM")))
      })
      .bottomSheet(
        isPresented: $store.isMenuBottomSheetPresented,
        detents: [.height(192)],
        leadingTitle: "설정",
        closeButtonAction: { store.send(.menuBottomSheetCloseButtonTapped) }
      ) {
        BKMenuBottomSheet(
          menuItems: [.editLink, .editFolder, .deleteLink],
          action: { store.send(.menuBottomSheetDelegate($0)) }
        )
        .interactiveDismissDisabled()
      }
      .bottomSheet(
        isPresented: $store.editFolderBottomSheet.isEditFolderBottomSheetPresented,
        detents: [.height(132)],
        leadingTitle: "폴더 수정",
        closeButtonAction: { store.send(.editFolderBottomSheet(.closeButtonTapped)) }
      ) {
        EditFolderBottomSheet(store: store.scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet))
          .interactiveDismissDisabled()
      }
      .fullScreenCover(
        item: $store.scope(
          state: \.editLink,
          action: \.editLink)
      ) { store in
        EditLinkView(store: store)
      }
    } //WithPerceptionTracking
  }
  
  //MARK: - ViewBuilder
  @ViewBuilder
  private var selectionCurrentPageView: some View {
    WithPerceptionTracking {
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
            store.send(.calendarAction(.currentSheetButtonTapped))
          } label: {
            BKIcon(image: CommonFeature.Images.icoClose, color: .bkColor(.black), size: .init(width: 16, height: 16))
          }
        }
        .padding(.horizontal, 28)
        
        LazyVGrid(columns: columns, spacing: 20) {
          ForEach(months, id: \.self) { month in
            Text(month.toString)
              .font(searchSheetMonthFont(targetMonth: month.rawValue))
              .frame(maxWidth: .infinity)
              .foregroundStyle(searchSheetMonthColor(targetMonth: month.rawValue))
              .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
              .onTapGesture {
                guard !isPast(targetMonth: month.rawValue) else {return}
                store.send(.calendarAction(.currentSheetMonthTapped(selectedMonth: month.rawValue)))
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
        store.send(.saveLinkButtonTapped)
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
  
  private var makeCategorySectionHeader: some View {
    let categories = store.article.folderList
    
    return WithPerceptionTracking {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack(spacing: 8) {
          ForEach(categories, id: \.self) { folder in
            let folderName = folder.folderName
            let feedCount = folder.feedCount
            let isSelectedIndex = (store.article.categorySelectedIndex == folder.folderId)
            
            Text("\(folderName) \(feedCount)")
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
                store.send(.articleAction(.changeCategorySelectedIndex(targetIndex: folder.folderId)))
              }
          }// Foreach
        } //LazyHStack
      } //ScrollView
      .frame(height: 40)
      .padding(EdgeInsets(top: 20, leading: 16, bottom: 16, trailing: 0))
    }// WithPerceptionTracking
  }
  
  @ViewBuilder
  private var cardCellView: some View {
    ForEach(store.article.filteredArticle, id: \.self) { value in
      WithPerceptionTracking {
        BKCardCell(
          sourceTitle: value.platform,
          sourceImage: value.platformImage,
          isMarked: value.isMarked,
          saveAction: { store.send(.articleAction(.cardItemSaveButtonTapped(value.feedId, !value.isMarked)), animation: .default) },
          menuAction: { store.send(.articleAction(.cardItemMenuButtonTapped(value))) },
          title: value.title,
          description: value.summary,
          keyword: value.keywords,
          isUncategorized: false
        )
        .onTapGesture {
          store.send(.articleAction(.cardItemTapped(value.feedId)))
        }
        .frame(width: 257)
      }
    } // Foreach
  }
}

//MARK: - Calculating Date Part
extension CalendarSearchView {
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
  
  private func isPast(targetMonth: Int) -> Bool {
    let currentDate = Date()
    
    let targetDate = calculatingCurrentSheetPageDate(month: targetMonth)
    
    let targetMonthTimeInterval = targetDate.timeIntervalSince1970
    
    if targetMonthTimeInterval >= currentDate.timeIntervalSince1970 {
      return true
    } else {
      return false
    }
  }
  
  private func searchSheetMonthFont(targetMonth: Int) -> Font {
    let targetDate = calculatingCurrentSheetPageDate(month: targetMonth)
    
    let currentPageComponents = calendar.dateComponents([.year, .month], from: store.calendar.currentPage)
    let currentPageSheetComponents = calendar.dateComponents([.year, .month], from: targetDate)
    
    guard currentPageComponents == currentPageSheetComponents else { return .regular(size: ._14) }
    
    return .semiBold(size: ._14)
    
  }
}
