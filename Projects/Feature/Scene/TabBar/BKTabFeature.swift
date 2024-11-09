//
//  BKTabFeature.swift
//  Blink
//
//  Created by kyuchul on 6/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

import Analytics
import Models

import CommonFeature

import ComposableArchitecture

@Reducer
public struct BKTabFeature {
  public init() {}
  
  @Reducer(state: .equatable)
  public enum Path {
    case Setting(SettingFeature)
    case SearchKeyword(SearchFeature)
    case Calendar(CalendarSearchFeature)
    case StorageBoxFeedList(StorageBoxFeedListFeature)
    case SaveLink(SaveLinkFeature)
    case SummaryStatus(SummaryStatusFeature)
    case Link(LinkFeature)
  }
  
  @ObservableState
  public struct State: Equatable {
    var currentItem: BKTabViewType = .home
    var path = StackState<Path.State>()
    
    var isSaveContentPresented = false
        
    var home: HomeFeature.State = .init()
    var storageBox: StorageBoxFeature.State = .init()
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onViewDidLoad
    case roundedTabIconTapped
    case saveLinkButtonTapped
    /// 피드 디테일 WillDisappear
    case feedDetailWillDisappear(Feed)
    
    // MARK: Inner Business Action
    
    // MARK: Inner SetState Action
    case setUnsavedSummaryAlertPresented
    
    // MARK: Delegate Action
    public enum Delegate {
      case logout
      case signout
    }
    
    case delegate(Delegate)
    
    
    case path(StackAction<Path.State, Path.Action>)
    case storageBox(StorageBoxFeature.Action)
    case home(HomeFeature.Action)
    
    // MARK: Navigation Action
    case routeSummaryCompleted(Int)
  }
  
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.storageBox, action: \.storageBox) { StorageBoxFeature() }
    Scope(state: \.home, action: \.home) { HomeFeature() }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.currentItem):
        if state.currentItem == .folder {
          tabbarStorageboxTappedLog()
        }
        
        state.isSaveContentPresented = false
        return .none
        
      case .onViewDidLoad:
        return .send(.setUnsavedSummaryAlertPresented)
                
        /// - 탭바 중앙 CIrcle 버튼 눌렀을 때
      case .roundedTabIconTapped:
        roundedTabIconTappedLog()
        
        state.isSaveContentPresented.toggle()
        return .none
        
        /// - 링크 저장 버튼 눌렀을 때
      case .saveLinkButtonTapped:
        state.isSaveContentPresented.toggle()
        state.path.append(.SaveLink(SaveLinkFeature.State()))
        return .none
                        
      case .setUnsavedSummaryAlertPresented:
        guard userDefaultsClient.integer(.latestUnsavedSummaryFeedId, -1) > 0 else {
          return .none
        }
        
        let feedId = userDefaultsClient.integer(.latestUnsavedSummaryFeedId, -1)
        return .run { send in
          await alertClient.present(.init(
            title: "작업 미완료 알림",
            description: """
                          아직 저장중인 링크가 있어요!
                          링크를 저장할 폴더를 지정해주세요
                          """,
            buttonType: .singleButton("저장하러 가기"),
            rightButtonAction: {
              await send(.routeSummaryCompleted(feedId))
            }
          ))
        }
                
        /// - 네비게이션 바 `세팅`버튼 눌렀을 때
      case .home(.delegate(.routeSetting)):
        state.path.append(.Setting(SettingFeature.State()))
        return .none
        
        /// - 세팅 -> `로그아웃` 했을 때
      case .path(.element(id: _, action: .Setting(.delegate(.logout)))):
        state.path.removeAll()
        return .send(.delegate(.logout))
        
        /// - 세팅 -> `회원탈퇴` 했을 때
      case .path(.element(id: _, action: .Setting(.delegate(.signout)))):
        state.path.removeAll()
        return .send(.delegate(.signout))
        
        /// - 상단 배너 `콘텐츠를 찾아드립니다` 눌렀을 때
      case .home(.delegate(.routeSearchKeyword)), .storageBox(.delegate(.routeSearchKeyword)):
        state.path.append(.SearchKeyword(SearchFeature.State()))
        return .none
        
        /// - 폴더 별 피드 리스트 ->  상단 배너  `콘텐츠를 찾아드립니다` 눌렀을 때
      case .path(.element(id: _, action: .StorageBoxFeedList(.delegate(.routeSearchKeyword)))):
        state.path.append(.SearchKeyword(SearchFeature.State()))
        return .none
                
        /// - 상단 배너  `캘린더`  버튼 눌렀을 때
      case .home(.delegate(.routeCalendar)), .storageBox(.delegate(.routeCalendar)):
        state.path.append(.Calendar(CalendarSearchFeature.State()))
        return .none
        
        /// - 홈 ->  `피드 디테일` 진입 시
      case let .home(.delegate(.routeFeedDetail(feedId))):
        state.path.append(.Link(LinkFeature.State(linkType: .feedDetail, feedId: feedId)))
        return .none
        
        /// - 검색 -> `피드 디테일` 진입 시
      case let .path(.element(id: _, action: .SearchKeyword(.delegate(.routeFeedDetail(feedId))))):
        state.path.append(.Link(LinkFeature.State(linkType: .feedDetail, feedId: feedId)))
        return .none
        
        ///  - 캘린더 검색 -> `피드 디테일` 진입 시
      case let .path(.element(id: _, action: .Calendar(.delegate(.routeFeedDetail(feedId))))):
        state.path.append(.Link(LinkFeature.State(linkType: .feedDetail, feedId: feedId)))
        return .none
        
        /// - 폴더 별 피드 리스트 -> `피드 디테일` 진입 시
      case let .path(.element(id: _, action: .StorageBoxFeedList(.delegate(.routeFeedDetail(feedId))))):
        state.path.append(.Link(LinkFeature.State(linkType: .feedDetail, feedId: feedId)))
        return .none
        
        /// - 피드 디테일 진입 후 `피드 삭제하기` 눌렀을 때
      case let .path(.element(id: _, action: .Link(.delegate(.deleteFeed(feed))))):
        state.path.removeLast()
        
        guard let stackElementId = state.path.ids.last,
              let lastPath = state.path.last else {
          return .send(.home(.feeds(.setDeleteFeed(feed.feedId))))
        }
        
        switch lastPath {
        case .SearchKeyword:
          return .send(.path(.element(id: stackElementId, action: .SearchKeyword(.setDeleteFeed(feed.feedId)))))
          
        case .StorageBoxFeedList:
          return .send(.path(.element(id: stackElementId, action: .StorageBoxFeedList(.feeds(.setDeleteFeed(feed.feedId))))))
        default:
          return .none
        }
        
        /// - 피드 디테일 진입 후 `뒤로가기` 버튼  눌렀을 때
      case .path(.element(id: _, action: .Link(.delegate(.feedDetailCloseButtonTapped)))):
        state.path.removeLast()
        return .none
        
        /// - 피드 디테일 진입 후 `WillDisappear` 됐을 때
      case let .feedDetailWillDisappear(feed):
        guard let stackElementId = state.path.ids.last,
              let lastPath = state.path.last else {
          return .send(.home(.feedDetailWillDisappear(feed)))
        }
        
        switch lastPath {
        case .SearchKeyword:
          return .send(.path(.element(id: stackElementId, action: .SearchKeyword(.feedDetailWillDisappear(feed)))))
          
        case .StorageBoxFeedList:
          return .send(.path(.element(id: stackElementId, action: .StorageBoxFeedList(.feedDetailWillDisappear(feed)))))
          
        case .Calendar:
          return .send(.path(.element(id: stackElementId, action: .Calendar(.feedDetailWillDisappear(feed)))))
          
        default:
          return .none
        }
                
        /// - 홈(미분류) -> `추천 폴더` 눌렀을 때  && 폴더함 -> `폴더` 진입 시
      case let .home(.delegate(.routeStorageBoxFeedList(folder))), let .storageBox(.delegate(.routeStorageBoxFeedList(folder))):
        state.path.append(.StorageBoxFeedList(StorageBoxFeedListFeature.State(folder: folder)))
        return .none
        
        /// - 홈 > 요약중 & 요약완료 토스트 -> `보러가기` 눌렀을 때
      case .home(.delegate(.routeSummaryStatusList)):
        state.path.append(.SummaryStatus(SummaryStatusFeature.State()))
        return .none
        
        /// - 링크 요약 리스트 화면 -> `요약 리스트 아이템` 눌렀을 때 `요약 완료 화면`으로 이동
      case let .path(.element(id: _, action: .SummaryStatus(.delegate(.summaryStatusItemTapped(feedId))))):
        return .send(.routeSummaryCompleted(feedId))
        
        /// - 요약 완료 화면 ->  `확인` 버튼 눌렀을 때 `링크 요약 이후 저장 화면`으로 이동
      case let .path(.element(id: _, action: .Link(.delegate(.summaryCompletedSaveButtonTapped(feedId))))):
        state.path.append(.Link(LinkFeature.State(linkType: .summarySave, feedId: feedId)))
        return .none
        
        /// - 요약 완료 화면 -> `확인` 버튼 누르지 않고 `뒤로가기` 버튼 눌렀을 때
      case .path(.element(id: _, action: .Link(.delegate(.summaryCompletedCloseButtonTapped)))):
        state.path.removeAll()
        return .none
        
        /// - 링크 요약 이후 저장 화면 -> `뒤로가기` 버튼 눌렀을 때
      case .path(.element(id: _, action: .Link(.delegate(.summarySaveCloseButtonTapped)))):
        state.path.removeAll()
        return .none
                
      case let .routeSummaryCompleted(feedId):
        state.path.append(.Link(LinkFeature.State(linkType: .summaryCompleted, feedId: feedId)))
        return .none
                
      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}

// MARK: Analytics Log

extension BKTabFeature {
  private func roundedTabIconTappedLog() {
    analyticsClient.logEvent(event: .init(name: .homeSummaryClicked, screen: .home))
  }
  
  private func tabbarStorageboxTappedLog() {
    analyticsClient.logEvent(event: .init(name: .homeTabbarStorageboxClicked, screen: .home))
  }
}
