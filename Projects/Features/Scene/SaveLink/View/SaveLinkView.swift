//
//  SaveLinkView.swift
//  Blink
//
//  Created by 문정호 on 4/29/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI
import CommonFeature

import ComposableArchitecture

public struct SaveLinkView: View {
  @Perception.Bindable var store: StoreOf<SaveLinkFeature>
  @Environment(\.dismiss) private var dismiss
  
  public var body: some View {
    WithPerceptionTracking {
      VStack(alignment: .leading) {
        HStack {
          Text("링크")
            .foregroundStyle(Color.bkColor(.main300))
          Text("를 입력해주세요")
            .foregroundStyle(Color.bkColor(.gray900))
        }
        .font(.semiBold(size: ._24))
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 4, trailing: 0))
        
        Text("블링크가 무엇이든 요약해줍니다")
          .frame(alignment: .leading)
          .font(.regular(size: ._14))
          .foregroundStyle(Color.bkColor(.gray700))
          .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 0))
        
        HStack(alignment: .top) {
          
          VStack(alignment: .leading) {
            ClearableTextField(
              text: $store.urlText,
              placeholder: "링크를 붙여주세요")
            .background(Color.bkColor(.white))
            .overlay(
              RoundedRectangle(cornerRadius: 10)
                .stroke(!store.isValidationURL ? Color.bkColor(.red) : Color.clear, lineWidth: 1)
            )
            
            if !store.state.isValidationURL {
              Text(store.validationReasonText)
                .font(.regular(size: ._12))
                .foregroundStyle(Color.bkColor(.red))
            }
          }
          
          Button {
            store.send(.onTapNextButton, animation: .default)
            hideKeyboard()
          } label: {
            CommonFeature.Images.icoChevronRight
              .renderingMode(.template)
              .foregroundStyle(store.saveButtonActive ?
                               Color.bkColor(.white) : Color.bkColor(.gray800))
          }
          .frame(width: 46, height: 46)
          .background(store.saveButtonActive ?
                      Color.bkColor(.main300) : Color.bkColor(.gray300))
          .clipShape(RoundedRectangle(cornerRadius: 10))
        }
      }
      .padding(EdgeInsets(top: 28, leading: 16, bottom: 0, trailing: 16))
      .navigationBarBackButtonHidden()
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button(action: {
            store.send(.onTapBackButton)
          }, label: {
            HStack{
              CommonFeature.Images.icoChevronLeft
              Text("링크 저장")
                .font(.semiBold(size: ._14))
                .foregroundStyle(Color.bkColor(.gray800))
            }
          })
          
        }
      }
      Spacer()
    }
  }
}
