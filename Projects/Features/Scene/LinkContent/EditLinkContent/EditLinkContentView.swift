//
//  EditLinkContentView.swift
//  Features
//
//  Created by kyuchul on 7/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture

struct EditLinkContentView: View {
  @Perception.Bindable var store: StoreOf<EditLinkContentFeature>
  
  var body: some View {
    WithPerceptionTracking {
      GeometryReader { _ in
        VStack(spacing: 0) {
          makeBKNavigationView(
            leadingType: .pop("내용수정"),
            trailingType: .pop(action: { store.send(.closeButtonTapped) })
          )
          
          VStack(alignment: .leading, spacing: 0) {
            BKText(
              text: "제목",
              font: .semiBold,
              size: ._18,
              lineHeight: 26,
              color: .bkColor(.gray900)
            )
            .padding(.top, 8)
            
            WithPerceptionTracking {
              BKTextField(
                text: $store.link.title,
                isHighlight: $store.isTitleVaild,
                textFieldType: .editLinkTitle,
                textCount: 50,
                isMultiLine: true,
                isClearButton: true,
                height: 67
              )
              .padding(.top, 4)
            }
            
            BKText(
              text: "요약 내용",
              font: .semiBold,
              size: ._18,
              lineHeight: 26,
              color: .bkColor(.gray900)
            )
            .padding(.top, 12)
            
            WithPerceptionTracking {
              BKTextField(
                text: $store.link.description,
                isHighlight: $store.isContentVaild,
                textFieldType: .editLinkContent,
                textCount: 200,
                isMultiLine: true,
                height: 160
              )
              .padding(.top, 4)
            }
            
            HStack {
              BKText(
                text: "키워드",
                font: .semiBold,
                size: ._18,
                lineHeight: 26,
                color: .bkColor(.gray900)
              )
              
              Spacer(minLength: 0)
              
              BKText(
                text: "키워드는 최대 3개까지 지정할 수 있어요",
                font: .regular,
                size: ._11,
                lineHeight: 26,
                color: .bkColor(.gray800)
              )
            }
            .padding(.top, 12)
            
            WithPerceptionTracking {
              BKChipView(
                keywords: $store.link.keyword,
                chipType: .edit
              )
              .padding(.top, 12)
            }
            
            HStack {
              BKText(
                text: "이미지",
                font: .semiBold,
                size: ._18,
                lineHeight: 26,
                color: .bkColor(.gray900)
              )
              
              Spacer(minLength: 0)
              
              BKText(
                text: "5MB 이하의 이미지만 첨부 가능해요",
                font: .regular,
                size: ._11,
                lineHeight: 26,
                color: .bkColor(.gray800)
              )
            }
            .padding(.top, 12)
            
            WithPerceptionTracking {
              BKPhotoPicker(
                selectedImages: $store.selectedImage,
                isPhotoError: $store.isPhotoError
              ) {
                EditPhotoItem(
                  currentImage: store.currentImage,
                  selectedImages: store.selectedImage
                )
              }
              .padding(.top, 12)
            }
            
            Spacer()
            
            WithPerceptionTracking {
              BKRoundedButton(
                title: "수정 완료",
                isDisabled: store.isTitleVaild && store.isContentVaild,
                confirmAction: { store.send(.editConfirmButtonTapped) }
              )
              .padding(.bottom, 14)
            }
          }
          .padding(.horizontal, 16)
        }
      }
      .tapToHideKeyboard()
      .ignoresSafeArea(.keyboard, edges: .bottom)
      .modal(
        isPresented: $store.isPresentedModal,
        type: store.isPhotoError == .type ? .photoTypeError(checkAction: {}, cancelAction: { store.isPresentedModal = false }) : .photoSizeError(checkAction: {}, cancelAction: { store.isPresentedModal = false })
      )
    }
  }
}

private struct EditPhotoItem: View {
  private let currentImage: UIImage
  private let selectedImages: [UIImage]
  
  init(
    currentImage: UIImage,
    selectedImages: [UIImage]
  ) {
    self.currentImage = currentImage
    self.selectedImages = selectedImages
  }
  
  var body: some View {
    if !selectedImages.isEmpty {
      imageView(Image(uiImage: selectedImages[0]))
    } else {
      imageView(Image(uiImage: currentImage))
    }
  }
  
  @MainActor
  private func imageView(_ image: Image) -> some View {
    image
      .resizable()
      .scaledToFill()
      .frame(width: 80, height: 80, alignment: .leading)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .overlay(alignment: .center) {
        VStack(spacing: 4) {
          BKIcon(
            image: CommonFeature.Images.icoImg,
            color: .white,
            size: .init(width: 24, height: 24)
          )
          
          Text("이미지 수정하기")
            .foregroundStyle(Color.white)
            .font(.semiBold(size: ._11))
        }
      }
  }
}
