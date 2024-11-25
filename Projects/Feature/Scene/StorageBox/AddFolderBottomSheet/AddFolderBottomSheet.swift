//
//  AddFolderBottomSheet.swift
//  Features
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture
import SwiftUIIntrospect

struct AddFolderBottomSheet: View {
  @Perception.Bindable var store: StoreOf<AddFolderBottomSheetFeature>
  @State private var textFieldDelegate = TextFieldDelegate()
  @FocusState private var textIsFocused: Bool
  
  var body: some View {
    GeometryReader { _ in
      WithPerceptionTracking {
        VStack(spacing: 0) {
          WithPerceptionTracking {
            BKTextField(
              text: $store.folderName,
              isValidation: store.isValidation,
              textIsFocused: _textIsFocused,
              textFieldType: .addFolder,
              textCount: 10,
              isMultiLine: false,
              errorMessage: store.errorMessage
            )
            .onChange(of: store.folderName) { newValue in
              store.send(.folderNameTextChanged(newValue))
            }
            .introspect(.textField, on: .iOS(.v16, .v17, .v18)) { textField in
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
    .onAppear { textIsFocused = true }
  }
}
