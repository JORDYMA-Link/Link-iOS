//
//  LinkFeature.swift
//  Features
//
//  Created by kyuchul on 7/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Analytics
import Services
import BKModel
import CommonFeature

import ComposableArchitecture

public enum LinkType: Equatable {
  /// 콘텐츠 디테일
  case feedDetail
  /// 링크 요약
  case summaryCompleted
  /// 링크 요약 이후 저장
  case summarySave
}

@Reducer
public struct LinkFeature {
  @ObservableState
  public struct State: Equatable {
    /// 콘텐츠 디테일 or 링크 요약 or 링크 요약 이후 저장 분기 처리
    var linkType: LinkType
    /// init FeedId
    var feedId: Int
    /// 콘텐츠 디테일 & 링크 요약 동일하게 쓰이는 Domain Model
    var feed: Feed = .init(feedId: 0, thumbnailImage: "", platformImage: "", title: "", date: "", summary: "", keywords: [], folderName: "", folders: [], memo: "", isMarked: false, originUrl: "")
    /// 링크 요약 화면 시 선택할 폴더
    var selectedFolder: String = ""
    
    /// 타이틀 편집/완료 버튼
    var isTitleUpdatable: Bool = true
    /// 요약 내용 편집/완료 버튼
    var isContentUpdatable: Bool = true
    /// 메모 편집/완료 버튼
    var isMemoUpdatable: Bool = true
    
    var webViewInfo: WebViewInfo = .init(flag: false, link: "")
    
    var isMenuBottomSheetPresented: Bool = false
    var isClipboardPopupPresented: Bool = false
    var isClipboardToastPresented: Bool = false
    var isOriginUrlPresented: Bool = false
    var isWebViewPresented: Bool = false
    
    @Presents var editLink: EditLinkFeature.State?
    
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    var addFolderBottomSheet: AddFolderBottomSheetFeature.State = .init()
    var addKeywordBottomSheet: AddKewordBottomSheetFeature.State = .init()
    var editMemoBottomSheet: EditMemoBottomSheetFeature.State = .init()
    
    public init(
      linkType: LinkType,
      feedId: Int
    ) {
      self.linkType = linkType
      self.feedId = feedId
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onTask
    case closeButtonTapped
    case closeBKWebView
    case openSurveyFormButtonTapped(String)
    case menuButtonTapped
    case saveButtonTapped(Bool)
    case shareButtonTapped
    case clipboardPopupSaveButtonTapped
    case titleUpdateButtonTapped
    case contentUpdateButtonTapped
    case chipItemDeleteButtonTapped(String)
    case chipItemAddButtonTapped
    case editFolderButtonTapped
    case recommendFolderItemTapped
    case addFolderItemTapped
    case folderItemTapped(any FolderItem)
    case memoUpdateButtonTapped
    case showURLButtonTapped
    case summaryDeleteButtonTapped
    case summarySaveButtonTapped
    
    // MARK: Inner Business Action
    case fetchFeedDetail(Int)
    case fetchLinkSummary(Int)
    case fetchWebViewInfo
    case deleteFeed(Int)
    case patchBookmark(Int, Bool)
    case patchFeed
    
    // MARK: Inner SetState Action
    case setFeed(Feed)
    case setLatestUnsavedSummaryFeedId(Int)
    case setWebViewInfo(WebViewInfo)
    
    // MARK: Delegate Action
    public enum Delegate {
      case summaryCompletedSaveButtonTapped(Int)
      case feedDetailCloseButtonTapped
      case summaryCompletedCloseButtonTapped
      case summarySaveCloseButtonTapped
      case deleteFeed(Feed)
    }
    case delegate(Delegate)
    
    // MARK: Child Action
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case addFolderBottomSheet(AddFolderBottomSheetFeature.Action)
    case addKeywordBottomSheet(AddKewordBottomSheetFeature.Action)
    case editMemoBottomSheet(EditMemoBottomSheetFeature.Action)
    case editLink(PresentationAction<EditLinkFeature.Action>)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    
    // MARK: Present Action
    case menuBottomSheetPresented(Bool)
    case clipboardPopupPresented(Bool)
    case clipboardToastPresented(Bool)
    case addKeywordBottomSheetPresented([String])
    case editLinkPresented
    case fetchFeedDetailFailAlertPresented
    case fetchLinkSummaryFailAlertPresented
    case saveLinkFailAlertPresented
    case closeWebViewPresented(Bool)
  }
  
  @Dependency(AnalyticsClient.self) private var analyticsClient
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(URLOpenHandlerClient.self) private var urlOpenHandlerClient
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.linkClient) private var linkClient
  @Dependency(\.feedClient) private var feedClient
  @Dependency(\.noticeClient) private var noticeClient
  
  private enum ThrottleId {
    case deleteButtonTapped
    case saveButtonTapped
    case summarySaveButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet) {
      EditFolderBottomSheetFeature()
    }
    
    Scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet) {
      AddFolderBottomSheetFeature()
    }
    
    Scope(state: \.addKeywordBottomSheet, action: \.addKeywordBottomSheet) {
      AddKewordBottomSheetFeature()
    }
    
    Scope(state: \.editMemoBottomSheet, action: \.editMemoBottomSheet) {
      EditMemoBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .onTask:
        switch state.linkType {
        case .feedDetail, .summarySave:
          return .run { [state] send in
            await send(.fetchFeedDetail(state.feedId))
          }
          
        case .summaryCompleted:
          return .run { [state] send in
            await send(.fetchLinkSummary(state.feedId))
          }
        }
        
      case .closeButtonTapped:
        switch state.linkType {
        case .feedDetail:
          return .run { send in
            await send(.delegate(.feedDetailCloseButtonTapped))
          }
        case .summaryCompleted:
          return .run { send in
            await send(.delegate(.summaryCompletedCloseButtonTapped))
          }
        case .summarySave:
          if state.webViewInfo.flag {
            state.webViewInfo.flag.toggle()
            
            return .send(.closeWebViewPresented(true))
          }
          
          return .send(.delegate(.summarySaveCloseButtonTapped))
        }
        
      case .closeBKWebView:
        return .send(.closeWebViewPresented(false))
        
      case let .openSurveyFormButtonTapped(surveyFormURL):
        return .run { send in
          await urlOpenHandlerClient.openURL(.custom(surveyFormURL))
        }
        
      case .menuButtonTapped:
        return .run { send in await send(.menuBottomSheetPresented(true)) }
        
      case let .saveButtonTapped(isMarked):
        let feedId = state.feed.feedId
        state.feed.isMarked = isMarked
        
        if isMarked {
          saveButtonTappedLog(feedId: feedId)
        }
        
        return .run { send in await send(.patchBookmark(feedId, isMarked)) }
          .throttle(id: ThrottleId.saveButtonTapped, for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
        
      case .shareButtonTapped:
        return .run { send in await send(.clipboardPopupPresented(true)) }
        
      case .clipboardPopupSaveButtonTapped:
        return .run { send in await send(.clipboardToastPresented(true)) }
        
      case .titleUpdateButtonTapped:
        state.isTitleUpdatable.toggle()
        return .none
        
      case .contentUpdateButtonTapped:
        state.isContentUpdatable.toggle()
        return .none
        
      case let .chipItemDeleteButtonTapped(keyword):
        if let index = state.feed.keywords.firstIndex(where: { $0 == keyword }) {
          state.feed.keywords.remove(at: index)
        }
        return .none
        
      case .chipItemAddButtonTapped:
        return .run { [state] send in await send(.addKeywordBottomSheetPresented(state.feed.keywords)) }
        
      case .editFolderButtonTapped:
        let feed = state.feed
        return .send(.editFolderBottomSheet(.editFolderTapped(feed.feedId, feed.folderName)))
        
      case .recommendFolderItemTapped:
        guard state.selectedFolder != state.feed.folderName else { return .none }
        
        state.selectedFolder = state.feed.folderName
        return .none
        
      case .addFolderItemTapped:
        return .send(.addFolderBottomSheet(.addFolderTapped))
        
      case let .folderItemTapped(folder):
        state.selectedFolder = folder.folderName
        return .none
        
      case .memoUpdateButtonTapped:
        state.isMemoUpdatable.toggle()
        return .none
        
      case .showURLButtonTapped:
        showURLButtonTappedLog(feedId: state.feed.feedId)
        
        state.isOriginUrlPresented = true
        return .none
        
      case .summaryDeleteButtonTapped:
        return .run { [state] send in
          await alertClient.present(.init(
            title: "삭제",
            description:"콘텐츠를 삭제하시면 복원이 어려워요",
            buttonType: .doubleButton(left: "취소", right: "확인"),
            rightButtonAction: { await send(.deleteFeed(state.feed.feedId)) }
          ))
        }
        
      case .summarySaveButtonTapped:
        summarySaveButtonTappedLog(feedId: state.feed.feedId)
        
        if state.feed.title.isEmpty || state.feed.summary.isEmpty {
          return .send(.saveLinkFailAlertPresented)
        }
        
        return .send(.patchFeed)
          .throttle(id: ThrottleId.summarySaveButtonTapped, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let .fetchFeedDetail(feedId):
        return .run(
          operation: { send in
            let feed = try await feedClient.getFeed(feedId)
            
            await send(.setFeed(feed), animation: .default)
          },
          catch: { error, send in
            print(error)
            await send(.fetchFeedDetailFailAlertPresented)
          }
        )
        
      case let .fetchLinkSummary(feedId):
        return .run(
          operation: { send in
            let feed = try await linkClient.getLinkSummary(feedId)
            
            await send(.setFeed(feed), animation: .default)
            await send(.setLatestUnsavedSummaryFeedId(feedId))
          },
          catch: { error, send in
            await send(.fetchLinkSummaryFailAlertPresented)
          }
        )
        
      case .fetchWebViewInfo:
        return fetchWebViewInfo()
        
      case let .deleteFeed(feedId):
        return .run(
          operation: { [state] send in
            _ = try await feedClient.deleteFeed(feedId)
            
            await send(.delegate(.deleteFeed(state.feed)))
          },
          catch: { error, send in
            print(error)
          }
        )
        .throttle(id: ThrottleId.deleteButtonTapped, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case let .patchBookmark(feedId, isMarked):
        return .run(
          operation: { send in
            let feedBookmark = try await feedClient.patchBookmark(feedId, isMarked)
            
            print(feedBookmark)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case .patchFeed:
        return .run(
          operation: { [state] send in
            async let feedIdResponse = try linkClient.patchLink(
              state.feed.feedId,
              state.selectedFolder,
              state.feed.title,
              state.feed.summary,
              state.feed.keywords,
              state.feed.memo
            )
            
            let feedId = try await feedIdResponse
            
            userDefaultsClient.set(-1, .latestUnsavedSummaryFeedId)
            
            await send(.delegate(.summaryCompletedSaveButtonTapped(feedId)))
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .setFeed(feed):
        state.selectedFolder = feed.folderName
        state.feed = feed
        return .none
        
      case let .setLatestUnsavedSummaryFeedId(feedId):
        userDefaultsClient.set(feedId, .latestUnsavedSummaryFeedId)
        return .none
        
      case let .setWebViewInfo(info):
        guard info.link.isHTTPURL else {
          return .none
        }
        
        state.webViewInfo = info
        return .none
        
      case let .editFolderBottomSheet(.delegate(.didUpdateFolder(_, folder))):
        guard state.feed.folderName != folder.name else { return .none }
        state.feed.folderName = folder.name
        return .none
        
      case let .addFolderBottomSheet(.delegate(.didUpdate(folder))):
        state.selectedFolder = folder.name
        
        var folderList = state.feed.folders ?? []
        folderList.insert(folder.name, at: 0)
        state.feed.folders = folderList
        return .none
        
      case let .editMemoBottomSheet(.delegate(.didUpdateMemo(feed))):
        state.feed.memo = feed.memo
        return .none
        
      case let .editLink(.presented(.delegate(.didUpdateLink(feed)))):
        return .send(.fetchFeedDetail(feed.feedId))
        
      case let .menuBottomSheetPresented(isPresented):
        state.isMenuBottomSheetPresented = isPresented
        return .none
        
      case .menuBottomSheet(.editLinkItemTapped):
        state.isMenuBottomSheetPresented = false
        return .run { send in
          try? await Task.sleep(for: .seconds(0.1))
          await send(.editLinkPresented)
        }
        
      case .menuBottomSheet(.deleteLinkItemTapped):
        state.isMenuBottomSheetPresented = false
        return .run { [state] send in
          await alertClient.present(.init(
            title: "삭제",
            description:"콘텐츠를 삭제하시면 복원이 어려워요",
            buttonType: .doubleButton(left: "취소", right: "확인"),
            rightButtonAction: { await send(.deleteFeed(state.feed.feedId)) }
          ))
        }
        
      case let .clipboardPopupPresented(isPresented):
        state.isClipboardPopupPresented = isPresented
        return .none
        
      case let .clipboardToastPresented(isPresented):
        state.isClipboardToastPresented = isPresented
        return .none
        
      case let .addKeywordBottomSheet(.delegate(.updateKeywords(keyword))):
        state.feed.keywords = keyword
        return .none
        
      case let .addKeywordBottomSheetPresented(keywords):
        return .send(.addKeywordBottomSheet(.addKeywordTapped(keywords)))
        
      case .editLinkPresented:
        state.editLink = .init(editLinkType: .link(state.feed))
        return .none
        
      case .fetchFeedDetailFailAlertPresented, .fetchLinkSummaryFailAlertPresented:
        return .run { send in
          await alertClient.present(.init(
            title: "에러 발생",
            description: """
                          에러가 발생했습니다. 
                          잠시 후 다시 시도해주세요.
                          """,
            buttonType: .singleButton("뒤로가기"),
            rightButtonAction: { await send(.closeButtonTapped) }
          ))
        }
        
      case .saveLinkFailAlertPresented:
        return .run { send in
          await alertClient.present(.init(
            title: "저장 불가",
            description: "제목과 요약 내용을 1글자 이상 입력해주세요.",
            buttonType: .singleButton("확인"),
            rightButtonAction: {}
          ))
        }
        
      case let .closeWebViewPresented(isPresented):
        state.isWebViewPresented = isPresented
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$editLink, action: \.editLink) {
      EditLinkFeature()
    }
  }
}

// MARK: Private

extension LinkFeature {
  private func fetchWebViewInfo() -> Effect<Action> {
    return .run(
      operation: { send in
        let info = try await noticeClient.getWebViewInfo()
        
        await send(.setWebViewInfo(info))
      },
      catch: { error, send in
        print(error)
      }
    )
  }
}

// MARK: Analytics Log

extension LinkFeature {
  private func saveButtonTappedLog(feedId: Int) {
    analyticsClient.logEvent(.init(name: .feedSaveBookmarkedClicked, screen: .feed_save, extraParameters: [.feedId: feedId]))
  }
  
  private func summarySaveButtonTappedLog(feedId: Int) {
    analyticsClient.logEvent(.init(name: .feedSaveConfirmClicked, screen: .feed_save, extraParameters: [.feedId: feedId]))
  }
  
  private func showURLButtonTappedLog(feedId: Int) {
    analyticsClient.logEvent(.init(name: .feedDetailLinkButtonClicked, screen: .feed_detail, extraParameters: [.feedId: feedId]))
  }
}
