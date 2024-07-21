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
    var isTitleVaild: Bool = false
    var isContentVaild: Bool = false
    
    var currentImage: UIImage = CommonFeature.Images.contentDetailBackgroundUIImage
    var selectedImage: [UIImage] = []
    var isPhotoError: PhotoPickerError?
    
    var isPresentedModal: Bool = false
    
    public init(link: LinkCard) {
      self.link = link
    }
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    
    // MARK: User Action
    case closeButtonTapped
    case selectedImagesChanged([UIImage])
    case editConfirmButtonTapped
    
    // MARK: Inner Business Action
    
    // MARK: Inner SetState Action
    
    // MARK: Child Action
  }
  
  @Dependency(\.dismiss) var dismiss
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .binding(\.link):
        return .none
        
      case .binding(\.isPhotoError):
        state.isPresentedModal = true
        return .none
        
      case .closeButtonTapped:
         return .run { _ in await self.dismiss() }
        
      case let .selectedImagesChanged(images):
        state.selectedImage = images
        return .none
      
      case .editConfirmButtonTapped:
        return .send(.closeButtonTapped)
                        
      default:
        return .none
      }
    }
  }
}
