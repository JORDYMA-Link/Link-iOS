//
//  IntegratedCalendarFeature.swift
//  Features
//
//  Created by 문정호 on 7/15/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models
import CommonFeature
import Analytics

import ComposableArchitecture

@Reducer
public struct CalendarSearchFeature {
  //MARK: - State
  @ObservableState
  public struct State: Equatable {
    //MARK: main State
    var isMenuBottomSheetPresented: Bool = false
    var calendarSearchData: SearchCalendar?
    var errorToastPresented: Bool = false
    
    //MARK: Child State
    var calendar = CalendarFeature.State()
    var article = CalendarArticleFeature.State()
    @Presents var editLink: EditLinkFeature.State?
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    
    //MARK: FeedCard
    var selectedFeed: FeedCard?
  }
  
  //MARK: - Action
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    //MARK: Child Action
    case calendarAction(CalendarFeature.Action)
    case articleAction(CalendarArticleFeature.Action)
    case editLink(PresentationAction<EditLinkFeature.Action>)
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    
    //MARK: Business Logic
    case spreadSearchData(_ searchCalendar: SearchCalendar)
    case editLinkPresented(Int)
    case deleteFeed(Int)
    //Update Logic Source States
    case updateSelectedFeed(FeedCard, Int)
    case bookmarkFeed(Int, Bool)
    case changeFolderSelectedFeedCard(FeedCard)
    case deleteSelectedFeedCard(Int)
    //Catch Error
    case catchNetworkError(Error)
    
    //MARK: Network
    case fetchCalendarData(yearMonth: String)
    case patchDeleteFeed(Int)
    case sendCalendarFeedTappedLog
    
    //MARK: User Action
    case naviBackButtonTapped
    case saveLinkButtonTapped
    case menuBottomSheetCloseButtonTapped
    
    //MARK: Delegate
    case delegate(CalendarSearchFeature.Delegate)
    case menuBottomSheetDelegate(BKMenuBottomSheet.Delegate)
    case feedDetailWillDisappear(Feed)
  }
  
  public enum Delegate {
    case routeFeedDetail(Int)
  }
  
  private enum ThrottleId {
    case updateFromServer
  }

  //MARK: - Dependency
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.feedClient) private var feedClient
  @Dependency(\.alertClient) private var alertClient
  @Dependency(AnalyticsClient.self) private var analyticsClient
  
  //MARK: - Body
  public var body: some ReducerOf<Self> {
    Scope(state: \.calendar, action: \.calendarAction) {
      CalendarFeature()
    }
    Scope(state: \.article, action: \.articleAction) {
      CalendarArticleFeature()
    }
    Scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet) {
      EditFolderBottomSheetFeature()
    }
    
    Reduce { state, action in
      switch action {
        //MARK: User Aciton
      case .naviBackButtonTapped:
        return .run { _ in await self.dismiss() }
        
      case .saveLinkButtonTapped:
        return .run { _ in await self.dismiss() }
        
      case .menuBottomSheetDelegate(.editLinkItemTapped):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        state.isMenuBottomSheetPresented = false
        return .run { send in
          try? await Task.sleep(for: .seconds(0.1))
          
          await send(.editLinkPresented(selectedFeed.feedId))
        }
        
      case .menuBottomSheetDelegate(.editFolderItemTapped):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        state.isMenuBottomSheetPresented = false
        return .run { send in
          try? await Task.sleep(for: .seconds(0.5))
          await send(.editFolderBottomSheet(.editFolderTapped(selectedFeed.feedId, selectedFeed.folderName)))
          }
        
      case .menuBottomSheetDelegate(.deleteLinkItemTapped):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        state.isMenuBottomSheetPresented = false
        return .run { send in
          await alertClient.present(.init(
            title: "삭제",
            description:
            """
            콘텐츠를 삭제하시면 복원이 어렵습니다.
            그래도 삭제하시겠습니까?
            """,
            buttonType: .doubleButton(left: "취소", right: "확인"),
            rightButtonAction: { await send(.patchDeleteFeed(selectedFeed.feedId)) }
          ))
        }
        
      case .menuBottomSheetCloseButtonTapped:
        state.isMenuBottomSheetPresented = false
        return .none
        

        //MARK: Business Action
      case let .spreadSearchData(searchCalendar):
        state.calendarSearchData = searchCalendar
        return .send(.calendarAction(.updatingEventDate(searchCalendar.existedFeedData.map{ $0.key })))
        
        
      case let .editLinkPresented(feedId):
        state.editLink = .init(editLinkType: .home(feedId: feedId))
        return .none
        
        
      case let .updateSelectedFeed(feed, targetFeedIndex):
        let selectedDate = state.calendar.selectedDate
      
        state.calendarSearchData?.existedFeedData[selectedDate]?.list[targetFeedIndex] = feed
        
        return .none
        
      case let .bookmarkFeed(targetFeedID, isMarked):
        let selectedDate = state.calendar.selectedDate
        
        guard let feedIndex = state.calendarSearchData?.existedFeedData[selectedDate]?.list.firstIndex(where: { $0.feedId == targetFeedID }) else { return .none }
        
        state.calendarSearchData?.existedFeedData[selectedDate]?.list[feedIndex].isMarked = isMarked
        
        return .none
        
      case let .changeFolderSelectedFeedCard(feed):
        let selectedDate = state.calendar.selectedDate
        
        guard let feedIndex = state.calendarSearchData?.existedFeedData[selectedDate]?.list.firstIndex(where: { $0.feedId == feed.feedId }) else { return .none }
        
        state.calendarSearchData?.existedFeedData[selectedDate]?.list[feedIndex].folderId = feed.folderId
        state.calendarSearchData?.existedFeedData[selectedDate]?.list[feedIndex].folderName = feed.folderName
        
        return .none
        
      case let .deleteSelectedFeedCard(targetFeedId):
        let selectedDate = state.calendar.selectedDate
        
        guard let feedIndex = state.calendarSearchData?.existedFeedData[selectedDate]?.list.firstIndex(where: { $0.feedId == targetFeedId }) else { return .none }
        
        state.calendarSearchData?.existedFeedData[selectedDate]?.list.remove(at: feedIndex)
        
        return .none
        
      case let .catchNetworkError(error):
        //FIXME: 에러 토스트 로직 구현 -> 토스트 로직만 구현하면 될 듯함.
        debugPrint(error)
        return .none
        
        //MARK: Network
      case let .fetchCalendarData(yearMonth):
        return .run (
          operation:{ send in
            let responseDTO = try await feedClient.getFeedCalendarSearch(yearMonth)
            
            await send(.spreadSearchData(responseDTO))
          }, catch: { error, send in
            await send(.catchNetworkError(error))
          })
        
      case let .patchDeleteFeed(feedId):
        return .run(
          operation: { send in
            _ = try await feedClient.deleteFeed(feedId)
            
            await send(.deleteSelectedFeedCard(feedId))
            await send(.articleAction(.deleteFeedCard(feedId)), animation: .default)
          }, catch: { error, send in
            await send(.catchNetworkError(error))
          }
        )
        
      case .sendCalendarFeedTappedLog:
        calendarFeedTappedLog()
        return .none
        
        //MARK: Delegate Action
        //FSCalendar
      case let .calendarAction(.delegate(.requestFetch(yearMonth))):
        return .run { send in
          await send(.fetchCalendarData(yearMonth: yearMonth))
        }
        
      case let .calendarAction(.delegate(.changeSelectedDateFeedCard(date))):
        guard let data = state.calendarSearchData?.existedFeedData[date]?.list else { return .none }
        
        state.article = CalendarArticleFeature.State(article: data)
        
        return .run { send in
          await send(.articleAction(.classifyFolder))
        }
        
        //Article
      case let .articleAction(.delegate(.shouldPresentsBottomSheet(selectedFeed))):
        state.selectedFeed = selectedFeed
        state.isMenuBottomSheetPresented = true
        return .none
        
      case let .articleAction(.delegate(.feedCardTapped(feedID))):
        return .run { send in
          await send(.delegate(.routeFeedDetail(feedID)))
          await send(.sendCalendarFeedTappedLog)
        }
        
      case let .articleAction(.delegate(.willChangeFolderOfParent(feed))):
        return .send(.changeFolderSelectedFeedCard(feed))
        
      case .articleAction(.delegate(.reloadSelectedDateFeedCard)):
        return .send(.calendarAction(.didSelectedDate(selectedDate: state.calendar.selectedDate)))
        
      case let .articleAction(.delegate(.willRemoveFeedOfParent(targetFeedID))):
        return .send(.deleteSelectedFeedCard(targetFeedID))
        
      case let .articleAction(.delegate(.willBookmarkFeedCard(targetFeedID, isMarked))):
        return .send(.bookmarkFeed(targetFeedID, isMarked))
        
        //BottomSheet
      case let .editFolderBottomSheet(.delegate(.didUpdateFolder(_, folder))):
        guard let selectedFeed = state.selectedFeed else { return .none }
        return .send(.articleAction(.changedFeedCardFolder(selectedFeed, folder)))
        
      case .editLink(.presented(.delegate(.didUpdateHome))):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        return .run { send in
          try await Task.sleep(for: .seconds(0.7))
          await send(.delegate(.routeFeedDetail(selectedFeed.feedId)))
        }
        
        // FeedDetail
        // Delegate 패턴이라기 보다는 Root에서 send하는 동작이지만 해당 Reducer 내에서는 Delegate로 구분하는게 편할듯 함.
      case let .feedDetailWillDisappear(feed):
        let selectedDate = state.calendar.selectedDate
        
        guard let feedIndex = state.calendarSearchData?.existedFeedData[selectedDate]?.list.firstIndex(where: { $0.feedId == feed.feedId }),
              let originFeedCard = state.calendarSearchData?.existedFeedData[selectedDate]?.list[feedIndex],
                originFeedCard != feed.toFeedCard(originFeedCard) else { return .none }
        
        let modifiedFeedCard = feed.toFeedCard(originFeedCard)
        
        return .run { send in
          await send(.updateSelectedFeed(modifiedFeedCard, feedIndex))
          await send(.articleAction(.feedCardUpdate(modifiedFeedCard)))
        }
        
      default:
        return .none
      }
    }
    .ifLet(\.$editLink, action: \.editLink) {
      EditLinkFeature()
    }
  }
}


extension CalendarSearchFeature {
  private func calendarFeedTappedLog() {
    analyticsClient.logEvent(event: .init(name: .calenderFeedClicked, screen: .calender))
  }
}
