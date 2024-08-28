//
//  AddKewordBottomSheet.swift
//  Features
//
//  Created by kyuchul on 8/18/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

struct AddKewordBottomSheet: View {
  @Perception.Bindable var store: StoreOf<AddKewordBottomSheetFeature>
  @FocusState private var textIsFocused: Bool
  
  var body: some View {
    WithPerceptionTracking {
      GeometryReader { _ in
        VStack(spacing: 0) {
          VStack(spacing: 8) {
            BKTextField(
              text: $store.text,
              isValidation: store.isValidation,
              textIsFocused: _textIsFocused,
              textFieldType: .addKeyword,
              textCount: 20,
              isMultiLine: false,
              errorMessage: "키워드는 최대 3개까지 지정할 수 있습니다.",
              height: 40
            )
            .onSubmit {
              store.send(.textFieldSubmitButtonTapped)
            }
            
            BKChipView(
              keywords: $store.keywords,
              chipType: .delete,
              deleteAction: { store.send(.chipItemDeleteButtonTapped($0)) }
            )
          }
          .padding(EdgeInsets(top: 12, leading: 20, bottom: 20, trailing: 20))
          
          Spacer(minLength: 0)
          
          BKRoundedButton(
            title: "완료",
            isDisabled: !store.isValidation,
            isCornerRadius: false,
            confirmAction: { store.send(.confirmButtonTapped) }
          )
        }
      }
      .ignoresSafeArea(.keyboard, edges: textIsFocused ? .top : .bottom)
      .onAppear { textIsFocused = true }
    }
  }
}
