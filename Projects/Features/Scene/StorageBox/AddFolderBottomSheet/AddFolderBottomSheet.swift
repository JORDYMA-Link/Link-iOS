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
  @Bindable var store: StoreOf<AddFolderBottomSheetFeature>
  @FocusState private var textIsFocused: Bool
  var textFieldDelegate = TextFieldDelegate()
  
  var body: some View {
    ZStack {
      Color.clear.ignoresSafeArea()
      
      VStack(spacing: 0) {
        BKTextField(
          text: $store.folderInput.title,
          isHighlight: $store.isHighlight,
          textIsFocused: _textIsFocused,
          textFieldType: .addFolder,
          textCount: 10,
          isMultiLine: false
        )
          .introspect(.textField, on: .iOS(.v17)) { textField in
              textField.delegate = textFieldDelegate
          }
          .frame(height: 36)
          .padding(EdgeInsets(top: 12, leading: 20, bottom: 20, trailing: 20))
        
        Spacer()
        
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
