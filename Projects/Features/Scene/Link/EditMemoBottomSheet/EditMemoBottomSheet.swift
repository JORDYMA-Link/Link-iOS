//
//  EditMemoBottomSheet.swift
//  Features
//
//  Created by kyuchul on 7/11/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture
import SwiftUIIntrospect

struct EditMemoBottomSheet: View {
  @Perception.Bindable var store: StoreOf<EditMemoBottomSheetFeature>
  @FocusState private var textIsFocused: Bool
  var textFieldDelegate = TextFieldDelegate()
  
  var body: some View {
    GeometryReader { _ in
      WithPerceptionTracking {
        VStack(spacing: 0) {
          WithPerceptionTracking {
            BKTextField(
              text: $store.memo,
              isValidation: store.isValidation,
              textIsFocused: _textIsFocused,
              textFieldType: .addMemo,
              textCount: 1000,
              isMultiLine: true,
              isClearButton: true,
              errorMessage: "메모는 1000자까지 입력 가능해요.",
              height: 126
            )
            .introspect(.textField, on: .iOS(.v16, .v17, v18)) { textField in
              textField.delegate = textFieldDelegate
            }
            .padding(EdgeInsets(top: 12, leading: 20, bottom: 20, trailing: 20))
          }
          
          Spacer(minLength: 0)
          
          BKRoundedButton(
            title: "완료",
            isDisabled: !store.isValidation,
            isCornerRadius: false,
            confirmAction: { store.send(.confirmButtonTapped) }
          )
        }
      }
    }
    .ignoresSafeArea(.keyboard, edges: textIsFocused ? .top : .bottom)
    .animation(.spring, value: textIsFocused)
    .onAppear {
      textIsFocused = true
    }
  }
}
