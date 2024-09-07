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

/// 콘텐츠 디테일 or 링크 요약 분기 처리 사용
public enum LinkType: Equatable {
  case feedDetail(feedId: Int)
  case summaryCompleted
}

@Reducer
public struct LinkFeature {
  @ObservableState
  public struct State: Equatable {
    /// 콘텐츠 디테일 or 링크 요약 분기 처리
    var linkType: LinkType
    /// 콘텐츠 디테일 & 링크 요약 동일하게 쓰이는 Domain Model
    var feed: Feed = .init(feedId: 0, thumnailImage: "", platformImage: "", title: "", date: "", summary: "", keywords: [], folderName: "", recommendFolders: [], memo: "", isMarked: false, originUrl: "")
    /// 링크 요약 화면 시 선택할 폴더
    var selectedFolder: String = ""
    /// 메모 타이틀
    var memoButtonTitle: String {
      feed.memo.isEmpty ? "추가" : "수정"
    }
    
    var isMenuBottomSheetPresented: Bool = false
    var isClipboardPopupPresented: Bool = false
    var isClipboardToastPresented: Bool = false
    
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    var editMemoBottomSheet: EditMemoBottomSheetFeature.State = .init()
    
    @Presents var editLink: EditLinkFeature.State?
    
    public init(linkType: LinkType) {
      self.linkType = linkType
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
    
    // MARK: Inner Business Action
    case fetchFeedDetail(Int)
    case deleteFeed(Int)
    case patchBookmark(Int, Bool)
    case patchFeed
    
    // MARK: Inner SetState Action
    case setFeed(Feed)
    
    // MARK: Delegate Action
    public enum Delegate {
      case deleteFeed(Feed)
    }
    case delegate(Delegate)
    
    // MARK: Child Action
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case editMemoBottomSheet(EditMemoBottomSheetFeature.Action)
    case editLink(PresentationAction<EditLinkFeature.Action>)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
    
    // MARK: Present Action
    case menuBottomSheetPresented(Bool)
    case clipboardPopupPresented(Bool)
    case clipboardToastPresented(Bool)
  }
  
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.linkClient) private var linkClient
  @Dependency(\.feedClient) private var feedClient
  
  private enum ThrottleId {
    case deleteButtonTapped
    case saveButtonTapped
  }
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet) {
      EditFolderBottomSheetFeature()
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
        case let .feedDetail(feedId):
          return .run { send in await send(.fetchFeedDetail(feedId)) }
          
        case .summaryCompleted:
          state.selectedFolder = state.feed.folderName
          return .none
        }
                
      case .closeButtonTapped:
        return .run { _ in await self.dismiss() }
        
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
        print("폴더추가 바텀시트 오픈")
        return .none
        
      case let .folderItemTapped(folder):
        state.selectedFolder = folder.folderName
        return .none
        
      case .editMemoButtonTapeed:
        let feed = state.feed
        return .send(.editMemoBottomSheet(.editMemoTapped(feed.feedId, feed.memo)))
        
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
        
      case let .deleteFeed(feedId):
        return .run(
          operation: { [state] send in
            _ = try await feedClient.deleteFeed(feedId)
            
            await send(.delegate(.deleteFeed(state.feed)))
            await dismiss()
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
            _ = try await linkClient.patchLink(
              state.feed.feedId,
              state.feed.folderName,
              state.feed.title,
              state.feed.summary,
              state.feed.keywords,
              state.feed.memo
            )
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .setFeed(feed):
        state.feed = feed
        return .none
        
      case let .editFolderBottomSheet(.delegate(.didUpdateFolder(_, folder))):
        guard state.feed.folderName != folder.name else { return .none }
        
        state.feed.folderName = folder.name
        
        switch state.linkType {
        case .feedDetail:
          return .run { send in await send(.patchFeed) }
          
        case .summaryCompleted:
          return .none
        }
        
      case let .editMemoBottomSheet(.delegate(.didUpdateMemo(feed))):
        state.feed.memo = feed.memo
        return .none
        
      case let .editLink(.presented(.delegate(.didUpdateLink(feed)))):
        return .send(.setFeed(feed))
        
      case let .menuBottomSheetPresented(isPresented):
        state.isMenuBottomSheetPresented = isPresented
        return .none
        
      case .menuBottomSheet(.editLinkItemTapped):
        state.isMenuBottomSheetPresented = false
        state.editLink = .init(editLinkType: .link(state.feed))
        return .none
        
      case .menuBottomSheet(.deleteLinkItemTapped):
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
        
      default:
        return .none
      }
    }
    .ifLet(\.$editLink, action: \.editLink) {
      EditLinkFeature()
    }
  }
}
