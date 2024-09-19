//
//  LinkFeature.swift
//  Features
//
//  Created by kyuchul on 7/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import CommonFeature
import Services
import Models

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
    /// 메모 타이틀
    var memoButtonTitle: String {
      feed.memo.isEmpty ? "추가" : "수정"
    }
    
    var isMenuBottomSheetPresented: Bool = false
    var isClipboardPopupPresented: Bool = false
    var isClipboardToastPresented: Bool = false
    var isWebViewPresented: Bool = false
    
    @Presents var editLink: EditLinkFeature.State?
    
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    var addFolderBottomSheet: AddFolderBottomSheetFeature.State = .init()
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
    case menuButtonTapped
    case saveButtonTapped(Bool)
    case shareButtonTapped
    case clipboardPopupSaveButtonTapped
    case editFolderButtonTapped
    case recommendFolderItemTapped
    case addFolderItemTapped
    case folderItemTapped(any FolderItem)
    case editMemoButtonTapeed
    case showURLButtonTapped
    case summaryEditButtonTapped
    case summarySaveButtonTapped
    
    // MARK: Inner Business Action
    case fetchFeedDetail(Int)
    case fetchLinkSummary(Int)
    case deleteFeed(Int)
    case patchBookmark(Int, Bool)
    case patchFeed
    
    // MARK: Inner SetState Action
    case setFeed(Feed)
    
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
    case editMemoBottomSheet(EditMemoBottomSheetFeature.Action)
    case editLink(PresentationAction<EditLinkFeature.Action>)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    
    // MARK: Present Action
    case menuBottomSheetPresented(Bool)
    case clipboardPopupPresented(Bool)
    case clipboardToastPresented(Bool)
    case editLinkPresented
  }
  
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.linkClient) private var linkClient
  @Dependency(\.feedClient) private var feedClient
  
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
          return .run { send in
            await send(.delegate(.summarySaveCloseButtonTapped))
          }
        }
        
      case .menuButtonTapped:
        return .run { send in await send(.menuBottomSheetPresented(true)) }
        
      case let .saveButtonTapped(isMarked):
        let feedId = state.feed.feedId
        state.feed.isMarked = isMarked
        return .run { send in await send(.patchBookmark(feedId, isMarked)) }
          .throttle(id: ThrottleId.saveButtonTapped, for: .seconds(2), scheduler: DispatchQueue.main, latest: false)
        
      case .shareButtonTapped:
        return .run { send in await send(.clipboardPopupPresented(true)) }
        
      case .clipboardPopupSaveButtonTapped:
        return .run { send in await send(.clipboardToastPresented(true)) }
        
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
        
      case .editMemoButtonTapeed:
        let feed = state.feed
        return .send(.editMemoBottomSheet(.editMemoTapped(feed.feedId, feed.memo)))
        
      case .showURLButtonTapped:
        state.isWebViewPresented = true
        return .none
        
      case .summaryEditButtonTapped:
        return .send(.editLinkPresented)
        
      case .summarySaveButtonTapped:
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
          }
        )
        
      case let .fetchLinkSummary(feedId):
        return .run(
          operation: { send in
            let feed = try await linkClient.getLinkSummary(feedId)
            
            await send(.setFeed(feed), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )
        
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
        
      case .editLinkPresented:
        state.editLink = .init(editLinkType: .link(state.feed))
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
