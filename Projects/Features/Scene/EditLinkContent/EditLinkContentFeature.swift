//
//  EditLinkContentFeature.swift
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
public struct EditLinkContentFeature {
  @ObservableState
  public struct State: Equatable {
    var link: LinkCard
    var isTitleValidation: Bool = true
    var isDescriptionValidation: Bool = true
    
    var currentImage: UIImage = CommonFeature.Images.contentDetailBackgroundUIImage
    var selectedImage: [UIImage] = []
    var isPhotoError: PhotoPickerError?
    
    var isPhotoErrorPresented: Bool = false
    
    var addKeywordBottomSheet: AddKewordBottomSheetFeature.State = .init()
    
    public init(link: LinkCard) {
      self.link = link
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
        state.link.title = title
        
        guard 2 <= state.link.title.count && state.link.title.count <= 50 else {
          return .send(.setTitleValidation(false))
        }
        
        return .send(.setTitleValidation(true))
        
      case let .descriptionChanged(description):
        state.link.description = description
        
        guard 2 <= state.link.description.count && state.link.description.count <= 200 else {
          return .send(.setDescriptionValidation(false))
        }
        
        return .send(.setDescriptionValidation(true))
        
      case let .chipItemDeleteButtonTapped(keyword):
        if let index = state.link.keyword.firstIndex(where: { $0 == keyword }) {
          state.link.keyword.remove(at: index)
        }
        return .none
        
      case .chipItemAddButtonTapped:
        return .run { [state] send in await send(.addKeywordBottomSheetPresented(state.link.keyword)) }
      
      case .editConfirmButtonTapped:
        return .send(.closeButtonTapped)
        
      case let .setTitleValidation(isTitleValidation):
        state.isTitleValidation = isTitleValidation
        return .none
        
      case let .setDescriptionValidation(isDescriptionValidation):
        state.isDescriptionValidation = isDescriptionValidation
        return .none
        
      case let .addKeywordBottomSheet(.delegate(.updateKeywords(keyword))):
        state.link.keyword = keyword
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
