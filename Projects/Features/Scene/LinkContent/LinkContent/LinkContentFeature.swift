//
//  LinkContentFeature.swift
//  Features
//
//  Created by kyuchul on 7/6/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Services
import Models

import ComposableArchitecture

@Reducer
public struct LinkContentFeature {
  @ObservableState
  public struct State: Equatable {
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    var editMemoBottomSheet: EditMemoBottomSheetFeature.State = .init()
    var linkMenuBottomSheet: LinkMenuBottomSheetFeature.State = .init()
    @Presents var editLinkContent: EditLinkContentFeature.State?
    
    var memo = "두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력"
    var memoButtonTitle: String {
      memo.isEmpty ? "추가" : "수정"
    }
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case closeButtonTapped
    case menuButtonTapped
    case editFolderButtonTapped
    case editMemoButtonTapeed
    
    // MARK: Inner Business Action
    
    // MARK: Inner SetState Action
    
    // MARK: Child Action
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case editMemoBottomSheet(EditMemoBottomSheetFeature.Action)
    case linkMenuBottomSheet(LinkMenuBottomSheetFeature.Action)
    case editLinkContent(PresentationAction<EditLinkContentFeature.Action>)
  }
  
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.editFolderBottomSheet, action: \.editFolderBottomSheet) {
      EditFolderBottomSheetFeature()
    }
    
    Scope(state: \.editMemoBottomSheet, action: \.editMemoBottomSheet) {
      EditMemoBottomSheetFeature()
    }
    
    Scope(state: \.linkMenuBottomSheet, action: \.linkMenuBottomSheet) {
      LinkMenuBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding:
        return .none
        
      case .closeButtonTapped:
         return .run { _ in await self.dismiss() }
        
      case .menuButtonTapped:
        return .send(.linkMenuBottomSheet(.linkMenuTapped(LinkCard.mock().first!)))
        
      case .editFolderButtonTapped:
        return .send(.editFolderBottomSheet(.editFolderTapped("test")))
        
      case let .linkMenuBottomSheet(.menuTapped(type)):
        state.linkMenuBottomSheet.isMenuBottomSheetPresented = false
        
        switch type {
        case .editLinkPost:
          state.editLinkContent = .init(link: LinkCard.mock().first!)
          return .none
        case .deleteLinkPost:
          print("deleteLinkPost")
          return .none
        }
        
      case .editMemoButtonTapeed:
        return .send(.editMemoBottomSheet(.editMemoTapped(state.memo)))
        
      case let .editMemoBottomSheet(.delegate(.didUpdateMemo(memo))):
        state.memo = memo
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$editLinkContent, action: \.editLinkContent) {
      EditLinkContentFeature()
    }
  }
}
