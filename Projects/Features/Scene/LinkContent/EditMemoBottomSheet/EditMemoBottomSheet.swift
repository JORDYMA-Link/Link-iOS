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
  @Bindable var store: StoreOf<EditMemoBottomSheetFeature>
  @FocusState private var textIsFocused: Bool
  var textFieldDelegate = TextFieldDelegate()
  
  var body: some View {
    ZStack {
      Color.clear.ignoresSafeArea()
      
      VStack(spacing: 0) {
        BKTextField(
          text: $store.memo,
          isHighlight: $store.isHighlight,
          textIsFocused: _textIsFocused,
          textFieldType: .addMemo,
          textCount: 1000,
          isMultiLine: true
        )
        .introspect(.textField, on: .iOS(.v17)) { textField in
          textField.delegate = textFieldDelegate
        }
        .frame(height: 90)
        .padding(EdgeInsets(top: 12, leading: 20, bottom: 20, trailing: 20))
        
        Spacer(minLength: 0)
        
        BKRoundedButton(
          title: "완료",
          isDisabled: store.isHighlight,
          isCornerRadius: false,
          confirmAction: { store.send(.confirmButtonTapped) }
        )
      }
    }
    .ignoresSafeArea(.keyboard, edges: textIsFocused ? .top : .bottom)
    .animation(.spring, value: textIsFocused)
    .onAppear {
      DispatchQueue.main.async {
        textIsFocused = true
      }
    }
  }
}
