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
      VStack(alignment: .leading, spacing: 0) {
        SaveLinkNavigationBar(store: store)
        
        VStack(alignment: .leading, spacing: 0) {
          HStack(spacing: 0) {
            Text("링크")
              .foregroundStyle(Color.bkColor(.main300))
            Text("를 입력해주세요")
              .foregroundStyle(Color.bkColor(.gray900))
          }
          .font(.semiBold(size: ._24))
          .padding(.bottom, 4)
          
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
      }
      .saveLinkBackground()
      .navigationBarBackButtonHidden()
      .toolbar(.hidden, for: .navigationBar)
    }
  }
}

private struct SaveLinkNavigationBar: View {
  @Perception.Bindable private var store: StoreOf<SaveLinkFeature>
  
  init(store: StoreOf<SaveLinkFeature>) {
    self.store = store
  }
  
  var body: some View {
    makeBKNavigationView(leadingType: .dismiss("링크 저장", { store.send(.onTapBackButton) }), trailingType: .none)
      .padding(.leading, 16)
  }
}


private extension View {
  @ViewBuilder
  func saveLinkBackground() -> some View {
    VStack(spacing: 0) {
      self
      Spacer()
    }
  }
}
