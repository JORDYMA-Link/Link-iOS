//
//  EditLinkView.swift
//  Features
//
//  Created by kyuchul on 7/12/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import BKModel
import BKCommon
import CommonFeature

import ComposableArchitecture
import Kingfisher

struct EditLinkView: View {
  @Perception.Bindable private var store: StoreOf<EditLinkFeature>
  
  init(store: StoreOf<EditLinkFeature>) {
    self.store = store
  }
  
  var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 0) {
        makeBKNavigationView(
          leadingType: .pop("내용수정"),
          trailingType: .pop(action: {
            HapticFeedbackManager.shared.notification(type: .error)
            store.send(.closeButtonTapped)
          })
        )
        
        ScrollView(showsIndicators: false) {
          VStack(alignment: .leading, spacing: 0) {
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
                text: "이미지는 최대 1장까지 불러올 수 있어요",
                font: .regular,
                size: ._11,
                lineHeight: 26,
                color: .bkColor(.gray800)
              )
            }
            .padding(.top, 8)
            
            HStack(spacing: 12) {
              PhotoItem(
                currentImage: store.feed.thumbnailImage,
                selectedPhotoInfos: store.selectedPhotoInfos
              )
              
              BKPhotoPicker(
                selectedPhotoInfos: $store.selectedPhotoInfos,
                isPhotoError: $store.isPhotoError
              ) {
                AddPhotoItem()
              }
            }
            .padding(.top, 12)
            
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
                errorMessage: "제목은 최소 1자, 최대 50자까지 입력 가능해요.",
                height: 67
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
                deleteAction: {
                  HapticFeedbackManager.shared.impact(style: .light)
                  store.send(.chipItemDeleteButtonTapped($0), animation: .default)
                },
                addAction: {
                  HapticFeedbackManager.shared.impact(style: .light)
                  store.send(.chipItemAddButtonTapped)
                }
              )
              .padding(.top, 12)
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
                textCount: 500,
                isMultiLine: true,
                errorMessage: "요약 내용은 최소 1자, 최대 500자까지 입력 가능해요.",
                height: 160
              )
              .padding(.top, 4)
            }
            
            BKText(
              text: "폴더",
              font: .semiBold,
              size: ._18,
              lineHeight: 26,
              color: .bkColor(.gray900)
            )
            .padding(.top, 12)
            
            BKAddFolderList(
              folderItemType: .default,
              folderList: store.feed.folders ?? [],
              selectedFolder: store.feed.folderName,
              itemAction: {
                HapticFeedbackManager.shared.selection()
                store.send(.folderItemTapped($0), animation: .default)
              },
              addAction: {
                HapticFeedbackManager.shared.selection()
                store.send(.addFolderItemTapped, animation: .default)
              }
            )
            .padding(.top, 12)
            .padding(.horizontal, -16)
            
            BKText(
              text: "메모",
              font: .semiBold,
              size: ._18,
              lineHeight: 26,
              color: .bkColor(.gray900)
            )
            .padding(.top, 12)
            
            WithPerceptionTracking {
              BKTextField(
                text: $store.feed.memo.sending(\.memoChanged),
                isValidation: store.isMemoValidation,
                textFieldType: .editLinkContent,
                textCount: 500,
                isMultiLine: true,
                errorMessage: "메모는 최대 500자까지 입력 가능해요.",
                height: 160
              )
              .padding(.top, 4)
            }
          }
          .padding(.horizontal, 16)
        }
      }
      .safeAreaInset(edge: .bottom, spacing: 0) {
        WithPerceptionTracking {
          BKRoundedButton(
            title: "수정 완료",
            isDisabled: !store.isTitleValidation || !store.isDescriptionValidation || !store.isMemoValidation,
            confirmAction: {
              HapticFeedbackManager.shared.impact(style: .medium)
              store.send(.editConfirmButtonTapped)
            }
          )
          .padding(.vertical, 14)
          .padding(.horizontal, 16)
          .background(.white)
        }
      }
      .tapToHideKeyboard()
      .bottomSheet(
        isPresented: $store.addKeywordBottomSheet.isAddKewordBottomSheetPresented,
        detents: [.height(240 - UIApplication.bottomSafeAreaInset)],
        leadingTitle: "키워드 추가",
        closeButtonAction: { store.send(.addKeywordBottomSheet(.closeButtonTapped)) }
      ) {
        AddKewordBottomSheet(store: store.scope(state: \.addKeywordBottomSheet, action: \.addKeywordBottomSheet))
      }
      .bottomSheet(
        isPresented: $store.addFolderBottomSheet.isAddFolderBottomSheetPresented,
        detents: [.height(202 - UIApplication.bottomSafeAreaInset)],
        leadingTitle: "폴더 추가",
        closeButtonAction: { store.send(.addFolderBottomSheet(.closeButtonTapped)) }
      ) {
        AddFolderBottomSheet(store: store.scope(state: \.addFolderBottomSheet, action: \.addFolderBottomSheet))
          .interactiveDismissDisabled()
      }
      .onAppear { store.send(.onAppear) }
    }
  }
}

private struct PhotoItem: View {
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
          .photoItemBackground()
      }
    } else {
      BKImageView(
        imageURL: currentImage,
        downsamplingSize: .init(width: 80, height: 80),
        placeholder: CommonFeature.Images.icoEmptyPhotoPicker
      )
      .photoItemBackground()
    }
  }
}

private struct AddPhotoItem: View {
  var body: some View {
    Rectangle()
      .fill(Color.bkColor(.gray400))
      .frame(width: 80, height: 80)
      .clipShape(RoundedRectangle(cornerRadius: 10))
      .overlay(alignment: .center) {
        BKIcon(
          image: CommonFeature.Images.icoFolderPlus,
          color: .bkColor(.gray700),
          size: .init(width: 24, height: 24)
        )
      }
  }
}

private extension View {
  func photoItemBackground() -> some View {
    self
      .frame(width: 80, height: 80)
      .clipShape(RoundedRectangle(cornerRadius: 10))
  }
}
