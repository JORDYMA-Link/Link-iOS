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

import ComposableArchitecture

@Reducer
public struct CalendarSearchFeature {
  //MARK: - State
  @ObservableState
  public struct State: Equatable {
    //MARK: main State
    var isMenuBottomSheetPresented: Bool = false
    var calendarSearchData: SearchCalendar?
    
    //MARK: Child State
    var calendar = CalendarFeature.State()
    var article = CalendarArticleFeature.State()
    @Presents var editLink: EditLinkFeature.State?
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    
    //MARK: FeedCard
    var selectedFeed: CalendarFeed?
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
    case fetchCalendarData(yearMonth: String)
    case spreadEachReducer(_ searchCalendar: SearchCalendar)
    case editLinkPresented(Int)
    case deleteFeed(Int)
    case feedDetailWillDisappear(Feed)
    case reloadSelectedFeed
    
    //MARK: Network
    case patchDeleteFeed(Int)
    
    //MARK: User Action
    case naviBackButtonTapped
    case saveLinkButtonTapped
    case menuBottomSheetCloseButtonTapped
    
    //MARK: Delegate
    case delegate(CalendarSearchFeature.Delegate)
    case menuBottomSheetDelegate(BKMenuBottomSheet.Delegate)
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
          
          await send(.editLinkPresented(selectedFeed.feedID))
        }
        
      case .menuBottomSheetDelegate(.editFolderItemTapped):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        state.isMenuBottomSheetPresented = false
        return .run { send in
          await send(.editFolderBottomSheet(.editFolderTapped(selectedFeed.feedID, selectedFeed.folderName))) }
        
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
            rightButtonAction: { await send(.patchDeleteFeed(selectedFeed.feedID)) }
          ))
        }
        
      case .menuBottomSheetCloseButtonTapped:
        state.isMenuBottomSheetPresented = false
        return .none
        

        //MARK: Business Action
      case let .spreadEachReducer(searchCalendar):
        state.calendarSearchData = searchCalendar
        return .run { send in
          await send(.calendarAction(.updatingEventDate(searchCalendar.existedFeedData.map{ $0.key })))
        }
        
        
      case let .editLinkPresented(feedId):
        state.editLink = .init(editLinkType: .home(feedId: feedId))
        return .none
        
        
      case let .deleteFeed(feedID):
        let selectedDate = state.calendar.selectedDate
        guard let index = state.calendarSearchData?.existedFeedData[selectedDate]?.list.firstIndex(where: { $0.feedID == feedID }) else { return .none }
        
        state.calendarSearchData?.existedFeedData[selectedDate]?.list.remove(at: index)
        
        return .none
        
      case let.feedDetailWillDisappear(feed):
        return .send(.reloadSelectedFeed)
        
      case .reloadSelectedFeed:
        return .send(.calendarAction(.didSelectedDate(selectedDate: state.calendar.selectedDate)))
          .throttle(id: ThrottleId.updateFromServer, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
        
        //MARK: Network
      case let .fetchCalendarData(yearMonth):
        return .run { send in
          let responseDTO = try await feedClient.getFeedCalendarSearch(yearMonth)
          
          await send(.spreadEachReducer(responseDTO))
        }
        
      case let .patchDeleteFeed(feedId):
        return .run(
          operation: { send in
            _ = try await feedClient.deleteFeed(feedId)
            
            await send(.deleteFeed(feedId))
            await send(.articleAction(.deleteFeedCard(feedId)), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )

        
        //MARK: Delegate Action
        //Calendar
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
        
        //Article
      case let .articleAction(.delegate(.shouldPresentsBottomSheet(selectedFeed))):
        state.selectedFeed = selectedFeed
        state.isMenuBottomSheetPresented = true
        return .none
        
      case let .articleAction(.delegate(.feedCardTapped(feedID))):
        return .send(.delegate(.routeFeedDetail(feedID)))
        
      case let .articleAction(.delegate(.willChangeFolderOfParent(feed))):
        let selectedDate = state.calendar.selectedDate
        
        guard let feedIndex = state.calendarSearchData?.existedFeedData[selectedDate]?.list.firstIndex(where: { $0.feedID == feed.feedID}) else { return .none }
        
        state.calendarSearchData?.existedFeedData[selectedDate]?.list[feedIndex].folderID = feed.folderID
        state.calendarSearchData?.existedFeedData[selectedDate]?.list[feedIndex].folderName = feed.folderName
        
        return .none
        
      case .articleAction(.delegate(.reloadSelectedDateFeedCard)):
        return .send(.calendarAction(.didSelectedDate(selectedDate: state.calendar.selectedDate)))
        
      case let .articleAction(.delegate(.willRemoveFeedOfParent(targetFeedID))):
        let selectedDate = state.calendar.selectedDate
        
        guard let feedIndex = state.calendarSearchData?.existedFeedData[selectedDate]?.list.firstIndex(where: { $0.feedID == targetFeedID }) else { return .none }
        
        state.calendarSearchData?.existedFeedData[selectedDate]?.list.remove(at: feedIndex)
        
        return .none
        
      case let .articleAction(.delegate(.willBookmarkFeedCard(targetFeedID, isMarked))):
        let selectedDate = state.calendar.selectedDate
        
        guard let feedIndex = state.calendarSearchData?.existedFeedData[selectedDate]?.list.firstIndex(where: { $0.feedID == targetFeedID }) else { return .none }
        
        state.calendarSearchData?.existedFeedData[selectedDate]?.list[feedIndex].isMarked = isMarked
        
        return .none
        //BottomSheet
      case let .editFolderBottomSheet(.delegate(.didUpdateFolder(_, folder))):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        return .send(.articleAction(.changedFeedCardFolder(selectedFeed, folder)))
        
      case .editLink(.presented(.delegate(.didUpdateHome))):
        guard let selectedFeed = state.selectedFeed else { return .none }
        
        return .run { send in
          try await Task.sleep(for: .seconds(0.7))
          await send(.articleAction(.cardItemTapped(selectedFeed.feedID)))
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
