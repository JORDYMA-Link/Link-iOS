//
//  EditLinkView.swift
//  Features
//
//  Created by kyuchul on 7/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature
import Models

import ComposableArchitecture
import Kingfisher

struct EditLinkView: View {
  @Perception.Bindable var store: StoreOf<EditLinkFeature>
  
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
                text: $store.feed.title.sending(\.titleTextChanged),
                isValidation: store.isTitleValidation,
                textFieldType: .editLinkTitle,
                textCount: 50,
                isMultiLine: true,
                isClearButton: true,
                errorMessage: "제목은 최소 2자, 최대 50자까지 입력 가능해요.",
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
                text: $store.feed.summary.sending(\.descriptionChanged),
                isValidation: store.isDescriptionValidation,
                textFieldType: .editLinkContent,
                textCount: 200,
                isMultiLine: true,
                errorMessage: "요약 내용은 최소 2자, 최대 200자까지 입력 가능해요.",
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
                keywords: $store.feed.keywords,
                chipType: .addWithDelete,
                deleteAction: { store.send(.chipItemDeleteButtonTapped($0)) },
                addAction: { store.send(.chipItemAddButtonTapped) }
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
                selectedPhotoInfos: $store.selectedPhotoInfos,
                isPhotoError: $store.isPhotoError
              ) {
                EditPhotoItem(
                  currentImage: store.feed.thumnailImage,
                  selectedPhotoInfos: store.selectedPhotoInfos
                )
              }
              .padding(.top, 12)
            }
            
            Spacer()
            
            WithPerceptionTracking {
              BKRoundedButton(
                title: "수정 완료",
                isDisabled: !store.isTitleValidation || !store.isDescriptionValidation,
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
      .bottomSheet(
        isPresented: $store.addKeywordBottomSheet.isAddKewordBottomSheetPresented,
        detents: [.height(240 - UIApplication.bottomSafeAreaInset)],
        leadingTitle: "키워드 추가",
        closeButtonAction: { store.send(.addKeywordBottomSheet(.closeButtonTapped)) }
      ) {
        AddKewordBottomSheet(store: store.scope(state: \.addKeywordBottomSheet, action: \.addKeywordBottomSheet))
      }
      .onAppear { store.send(.onAppear) }
    }
  }
}

private struct EditPhotoItem: View {
  private let currentImage: String
  private let selectedPhotoInfos: [Data]
  
  init(
    currentImage: String,
    selectedPhotoInfos: [Data]
  ) {
    self.currentImage = currentImage
    self.selectedPhotoInfos = selectedPhotoInfos
  }
  
  var body: some View {
    if !selectedPhotoInfos.isEmpty {
      if let image = UIImage(data: selectedPhotoInfos[0]) {
        Image(uiImage: image)
          .resizable()
          .scaledToFill()
          .editPhotoItem()
      }
    } else {
      BKImageView(
        imageURL: currentImage,
        downsamplingSize: .init(width: 80, height: 80),
        placeholder: CommonFeature.Images.contentDetailBackground
      )
      .editPhotoItem()
    }
  }
}

private extension View {
  func editPhotoItem() -> some View {
    self
      .frame(width: 80, height: 80)
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
