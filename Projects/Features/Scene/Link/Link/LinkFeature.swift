//
//  LinkContentFeature.swift
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
public enum LinkCotentType {
  case contentDetail
  case summaryCompleted
}

@Reducer
public struct LinkFeature {
  @ObservableState
  public struct State: Equatable {
    /// 콘텐츠 디테일 or 링크 요약 분기 처리
    var linkCotentType: LinkCotentType
    /// 콘텐츠 디테일 화면 데이터
    var linkContent: LinkDetail = .mock()
    /// 링크 요약 화면  데이터
    var summary: Summary = .makeSummaryMock()
    /// 링크 요약 화면 시 선택할 폴더
    var selectedFolder: String = ""
    /// 메모
    var memo: String = "memo"
    /// 메모 타이틀
    var memoButtonTitle: String {
      memo.isEmpty ? "추가" : "수정"
    }
    
    var isMenuBottomSheetPresented: Bool = false
    var isClipboardPopupPresented: Bool = false
    var isClipboardToastPresented: Bool = false
    
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    var editMemoBottomSheet: EditMemoBottomSheetFeature.State = .init()
    
    @Presents var editLinkContent: EditLinkFeature.State?
    
    public init(linkCotentType: LinkCotentType) {
      self.linkCotentType = linkCotentType
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onTask
    case closeButtonTapped
    case menuButtonTapped
    case shareButtonTapped
    case clipboardPopupSaveButtonTapped
    case editFolderButtonTapped
    case recommendFolderItemTapped
    case addFolderItemTapped
    case folderItemTapped(any FolderItem)
    case editMemoButtonTapeed
    
    // MARK: Inner Business Action
    case menuBottomSheetPresented(Bool)
    case clipboardPopupPresented(Bool)
    case clipboardToastPresented(Bool)
    
    // MARK: Inner SetState Action
    
    // MARK: Child Action
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case editMemoBottomSheet(EditMemoBottomSheetFeature.Action)
    case editLinkContent(PresentationAction<EditLinkFeature.Action>)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
  }
  
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.linkClient) private var linkClient
  @Dependency(\.feedClient) private var feedClient
  
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
        state.selectedFolder = state.summary.recommend
        return .none
        
      case .closeButtonTapped:
         return .run { _ in await self.dismiss() }
        
      case .menuButtonTapped:
        return .run { send in await send(.menuBottomSheetPresented(true)) }
        
      case .shareButtonTapped:
        return .run { send in await send(.clipboardPopupPresented(true)) }
        
      case .clipboardPopupSaveButtonTapped:
        return .run { send in await send(.clipboardToastPresented(true)) }
                        
      case .editFolderButtonTapped:
        return .send(.editFolderBottomSheet(.editFolderTapped("test")))
        
      case .recommendFolderItemTapped:
        guard state.selectedFolder != state.summary.recommend else { return .none }
                
        state.selectedFolder = state.summary.recommend
        return .none
        
      case .addFolderItemTapped:
        print("폴더추가 바텀시트 오픈")
        return .none
        
      case let .folderItemTapped(folder):
        state.selectedFolder = folder.folderName
        return .none
        
      case .editMemoButtonTapeed:
        return .send(.editMemoBottomSheet(.editMemoTapped(state.memo)))
        
      case let .editMemoBottomSheet(.delegate(.didUpdateMemo(memo))):
        state.memo = memo
        return .none
        
      case let .menuBottomSheetPresented(isPresented):
        state.isMenuBottomSheetPresented = isPresented
        return .none
        
      case .menuBottomSheet(.editLinkContentCellTapped):
        state.isMenuBottomSheetPresented = false
        state.editLinkContent = .init(feed: Feed.mock())
        return .none
        
      case .menuBottomSheet(.deleteLinkContentCellTapped):
        print("deleteModal")
        return .none
        
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
    .ifLet(\.$editLinkContent, action: \.editLinkContent) {
      EditLinkFeature()
    }
  }
}
