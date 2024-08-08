//
//  EditFolderNameBottomSheet.swift
//  Features
//
//  Created by kyuchul on 6/18/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture
import SwiftUIIntrospect

struct EditFolderNameBottomSheet: View {
  @Bindable var store: StoreOf<EditFolderNameBottomSheetFeature>
  @FocusState private var textIsFocused: Bool
  var textFieldDelegate = TextFieldDelegate()
  
  var body: some View {
    GeometryReader { _ in
      VStack(spacing: 0) {
        BKTextField(
          text: $store.folderInput.title,
          isHighlight: $store.isHighlight,
          textIsFocused: _textIsFocused,
          textFieldType: .editFolderName,
          textCount: 10,
          isMultiLine: false
        )
          .introspect(.textField, on: .iOS(.v17)) { textField in
              textField.delegate = textFieldDelegate
          }
          .padding(EdgeInsets(top: 12, leading: 20, bottom: 20, trailing: 20))
        
        Spacer(minLength: 0)
        
        BKRoundedButton(title: "완료", isDisabled: store.isHighlight, isCornerRadius: false, confirmAction: { store.send(.confirmButtonTapped) })
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

final class TextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}
