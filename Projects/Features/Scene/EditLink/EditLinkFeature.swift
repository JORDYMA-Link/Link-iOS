//
//  EditLinkFeature.swift
//  Features
//
//  Created by kyuchul on 7/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import UIKit

import Models
import Services
import CommonFeature

import ComposableArchitecture

public enum EditLinkType: Equatable {
  case home(feedId: Int)
  case link(Feed)
}

@Reducer
public struct EditLinkFeature {
  @ObservableState
  public struct State: Equatable {
    var editLinkType: EditLinkType
    var feed: Feed = .init(feedId: 0, thumnailImage: "", platformImage: "", title: "", date: "", summary: "", keywords: [], folderName: "", folders: [], memo: "", isMarked: false, originUrl: "")
    var initFeed: Feed?
    var isTitleValidation: Bool = true
    var isDescriptionValidation: Bool = true
    
    var selectedPhotoInfos: [Data] = []
    var isPhotoError: PhotoPickerError?
    var isPhotoErrorPresented: Bool = false
    
    var addKeywordBottomSheet: AddKewordBottomSheetFeature.State = .init()
    
    public init(
      editLinkType: EditLinkType
    ) {
      self.editLinkType = editLinkType
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case onAppear
    case closeButtonTapped
    case titleTextChanged(String)
    case descriptionChanged(String)
    case chipItemDeleteButtonTapped(String)
    case chipItemAddButtonTapped
    case editConfirmButtonTapped
    
    // MARK: Inner Business Action
    case fetchFeed(Int)
    case postThumbnailImage(Int, Data)
    case patchLink(Int)
    case dismiss
    
    // MARK: Inner SetState Action
    case setFeed(Feed)
    case setTitleValidation(Bool)
    case setDescriptionValidation(Bool)
    case setDelegate
    
    // MARK: Delegate Action
    public enum Delegate {
      /// 디테일 or 요약 완료 화면으로 dismiss
      case didUpdateLink(Feed)
      /// 홈 화면으로 dismiss
      case didUpdateHome(Feed)
    }
    case delegate(Delegate)
    
    // MARK: Child Action
    case addKeywordBottomSheet(AddKewordBottomSheetFeature.Action)
    
    // MARK: Present Action
    case addKeywordBottomSheetPresented([String])
    case photoErrorAlertPresented
  }
  
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.linkClient) private var linkClient
  @Dependency(\.feedClient) private var feedClient
  
  public var body: some ReducerOf<Self> {
    Scope(state: \.addKeywordBottomSheet, action: \.addKeywordBottomSheet) {
      AddKewordBottomSheetFeature()
    }
    
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.isPhotoError):
        state.isPhotoErrorPresented = true
        return .run { send in await send(.photoErrorAlertPresented) }
        
      case .onAppear:
        switch state.editLinkType {
        case let .link(feed):
          return .send(.setFeed(feed))
        case let .home(feedId):
          return .send(.fetchFeed(feedId))
        }
        
      case .closeButtonTapped:
        return .run { send in
          await alertClient.present(.init(
            title: "편집 중단",
            description:
            """
            편집을 중단하시겠어요?
            수정한 내용이 반영되지 않아요
            """,
            buttonType: .doubleButton(left: "나가기", right: "취소"),
            leftButtonAction: { await send(.dismiss) },
            rightButtonAction: {}
          ))
        }
        
      case let .titleTextChanged(title):
        state.feed.title = title
        
        guard 2 <= state.feed.title.count && state.feed.title.count <= 50 else {
          return .send(.setTitleValidation(false))
        }
        
        return .send(.setTitleValidation(true))
        
      case let .descriptionChanged(description):
        state.feed.summary = description
        
        guard 2 <= state.feed.summary.count && state.feed.summary.count <= 200 else {
          return .send(.setDescriptionValidation(false))
        }
        
        return .send(.setDescriptionValidation(true))
        
      case let .chipItemDeleteButtonTapped(keyword):
        if let index = state.feed.keywords.firstIndex(where: { $0 == keyword }) {
          state.feed.keywords.remove(at: index)
        }
        return .none
        
      case .chipItemAddButtonTapped:
        return .run { [state] send in await send(.addKeywordBottomSheetPresented(state.feed.keywords)) }
        
      case .editConfirmButtonTapped:
        if let selectedPhoto = state.selectedPhotoInfos.first {
          return .run { [state] send in await send(.postThumbnailImage(state.feed.feedId, selectedPhoto)) }
        }
        
        guard state.feed != state.initFeed else {
          return .run { _ in await self.dismiss() }
        }
        
        return .run { [state] send in await send(.patchLink(state.feed.feedId)) }
        
      case let .postThumbnailImage(feedId, selectedPhoto):
        return .run(
          operation: { send in
            let imageURL = try await linkClient.postLinkImage(feedId, selectedPhoto)
            
            print(imageURL)
            
            await send(.patchLink(feedId))
          },
          catch: { error, send in
            print(error)
            /// 성공 시 200 애러로 방출됨 (추후 수정 필요)
            await send(.patchLink(feedId))
          }
        )
        
      case let .fetchFeed(feedId):
        return .run(
          operation: { send in
            let feed = try await feedClient.getFeed(feedId)
            
            await send(.setFeed(feed), animation: .default)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .patchLink(feedId):
        return .run(
          operation: { [state] send in
            _ = try await linkClient.patchLink(
              feedId,
              state.feed.folderName,
              state.feed.title,
              state.feed.summary,
              state.feed.keywords,
              state.feed.memo
            )
            
            await send(.setDelegate)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case .dismiss:
        return .run { _ in await self.dismiss() }
        
      case let .setFeed(feed):
        state.feed = feed
        state.initFeed = feed
        return .none
        
      case let .setTitleValidation(isTitleValidation):
        state.isTitleValidation = isTitleValidation
        return .none
        
      case let .setDescriptionValidation(isDescriptionValidation):
        state.isDescriptionValidation = isDescriptionValidation
        return .none
        
      case .setDelegate:
        return .run { [state] send in
          switch state.editLinkType {
          case .home:
            await send(.delegate(.didUpdateHome(state.feed)))
          case .link:
            await send(.delegate(.didUpdateLink(state.feed)))
          }
          
          await send(.dismiss)
        }
        
      case let .addKeywordBottomSheet(.delegate(.updateKeywords(keyword))):
        state.feed.keywords = keyword
        return .none
        
      case let .addKeywordBottomSheetPresented(keywords):
        return .send(.addKeywordBottomSheet(.addKeywordTapped(keywords)))
        
      case .photoErrorAlertPresented:
        return .run { [state] send in
          guard let error = state.isPhotoError else { return }
          
          await alertClient.present(.init(
            title: error.title,
            description: error.message,
            buttonType: .singleButton(),
            rightButtonAction: {}
          ))
        }
        
      default:
        return .none
      }
    }
  }
}
