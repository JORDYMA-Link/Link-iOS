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

@Reducer
public struct LinkContentFeature {
  @ObservableState
  public struct State: Equatable {
    var editFolderBottomSheet: EditFolderBottomSheetFeature.State = .init()
    var editMemoBottomSheet: EditMemoBottomSheetFeature.State = .init()
    
    @Presents var editLinkContent: EditLinkContentFeature.State?

    var memo = "두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력 두줄 입력 두줄 입력 두중ㄹ입력 ㄷ두줄 입력 두줄 입력"
    var memoButtonTitle: String {
      memo.isEmpty ? "추가" : "수정"
    }
    
    var isMenuBottomSheetPresented: Bool = false
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
    case menuBottomSheetPresented(Bool)
    
    // MARK: Inner SetState Action
    
    // MARK: Child Action
    case editFolderBottomSheet(EditFolderBottomSheetFeature.Action)
    case editMemoBottomSheet(EditMemoBottomSheetFeature.Action)
    case editLinkContent(PresentationAction<EditLinkContentFeature.Action>)
    case menuBottomSheet(BKMenuBottomSheet.Delegate)
  }
  
  @Dependency(\.dismiss) var dismiss
  
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
        
      case .closeButtonTapped:
         return .run { _ in await self.dismiss() }
        
      case .menuButtonTapped:
        return .run { send in await send(.menuBottomSheetPresented(true)) }
                        
      case .editFolderButtonTapped:
        return .send(.editFolderBottomSheet(.editFolderTapped("test")))
        
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
        state.editLinkContent = .init(link: LinkCard.mock().first!)
        return .none
        
      case .menuBottomSheet(.deleteLinkContentCellTapped):
        print("deleteModal")
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
