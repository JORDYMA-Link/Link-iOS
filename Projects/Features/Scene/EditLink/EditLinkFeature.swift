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

@Reducer
public struct EditLinkFeature {
  @ObservableState
  public struct State: Equatable {
    var feed: Feed
    var isTitleValidation: Bool = true
    var isDescriptionValidation: Bool = true
    
    var selectedPhotoInfos: [Data] = []
    var isPhotoError: PhotoPickerError?
    var isPhotoErrorPresented: Bool = false
    
    var addKeywordBottomSheet: AddKewordBottomSheetFeature.State = .init()
    
    public init(feed: Feed) {
      self.feed = feed
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case closeButtonTapped
    case titleTextChanged(String)
    case descriptionChanged(String)
    case chipItemDeleteButtonTapped(String)
    case chipItemAddButtonTapped
    case editConfirmButtonTapped
    
    // MARK: Inner Business Action
    
    // MARK: Inner SetState Action
    case postThumbnailImage(Int)
    case patchLink(Int)
    case setTitleValidation(Bool)
    case setDescriptionValidation(Bool)
    
    // MARK: Child Action
    case addKeywordBottomSheet(AddKewordBottomSheetFeature.Action)
    
    // MARK: Present Action
    case addKeywordBottomSheetPresented([String])
    case photoErrorAlertPresented
  }
  
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.linkClient) private var linkClient
  
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
        
      case .closeButtonTapped:
        return .run { _ in await self.dismiss() }
        
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
        return .run { [state] send in await send(.postThumbnailImage(state.feed.feedId)) }
        
      case let .postThumbnailImage(feedId):
        guard let selectedPhoto = state.selectedPhotoInfos.first else {
          return .send(.patchLink(feedId))
        }
        
        return .run(
          operation: { send in
            let imageURL = try await linkClient.postLinkImage(feedId, selectedPhoto)
            
            print(imageURL)
            
            await send(.patchLink(feedId))
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
            
            await send(.closeButtonTapped)
          },
          catch: { error, send in
            print(error)
          }
        )
        
      case let .setTitleValidation(isTitleValidation):
        state.isTitleValidation = isTitleValidation
        return .none
        
      case let .setDescriptionValidation(isDescriptionValidation):
        state.isDescriptionValidation = isDescriptionValidation
        return .none
        
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
