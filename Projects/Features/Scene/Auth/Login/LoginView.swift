//
//  LoginView.swift
//  Blink
//
//  Created by kyuchul on 5/31/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

public struct LoginView: View {
  @Bindable var store: StoreOf<LoginFeature>
  @State private var pushToOnboarding = false
  
  public init(store: StoreOf<LoginFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      ZStack {
        Color.white
        
        VStack(alignment: .center, spacing: 0) {
          Spacer()
          
          makeLogo()
          makeTitle()
          
          Spacer()
          
          VStack(spacing: 12) {
            makeLoginButton(action: {
              store.send(.kakaoLoginButtonTapped)
            }, backgroundColor: .bkColor(.kakaoYellow), title: "카카오톡으로 시작하기", titleColor: .bkColor(.gray900), buttonImage: CommonFeature.Images.icokakao, buttonImageColor: .bkColor(.gray900))
            
            makeLoginButton(action: {
              store.send(.appleLoginButtonTapped)
            }, backgroundColor: .bkColor(.black), title: "Apple로 시작하기", titleColor: .bkColor(.white), buttonImage: CommonFeature.Images.icoapple, buttonImageColor: .bkColor(.white))
            
            makeTerms(
              serviceTerms:makeTermsText("서비스 약관", url: "https://upbit.com/home"),
              privacyPolicy: makeTermsText("개인정보 처리방침", url: "https://www.bithumb.com/react")
            )
          }
        }
      }
    }
  }
  
  @ViewBuilder
  private func makeLogo() -> some View {
    ZStack {
      RoundedRectangle(cornerRadius: 25, style: .continuous)
        .fill(Color.bkColor(.main300))
        .frame(width: 135, height: 135)
      
      BKIcon(image: CommonFeature.Images.logoWhite, color: .white, size: CGSize(width: 64, height: 70))
    }
  }
  
  @ViewBuilder
  private func makeTitle() -> some View {
    Text("눈 깜짝할 새 저장되는\nAI 링크 아카이빙, 블링크")
      .font(.semiBold(size: ._20))
      .foregroundStyle(Color.bkColor(.gray900))
      .multilineTextAlignment(.center)
      .padding(.top, 16)
      .frame(alignment: .center)
  }
  
  @ViewBuilder
  private func makeLoginButton(action: @escaping () -> (), backgroundColor: Color, title: String, titleColor: Color, buttonImage: Image, buttonImageColor: Color) -> some View {
    Button {
      action()
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .fill(backgroundColor)
          .frame(maxWidth: .infinity)
        
        HStack(spacing: 4) {
          BKIcon(image: buttonImage, color: buttonImageColor, size: CGSize(width: 20, height: 20))
          
          Text(title)
            .font(.semiBold(size: ._16))
            .foregroundStyle(titleColor)
            .multilineTextAlignment(.center)
        }
        .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
      }
      .padding(.top)
      .padding(.horizontal, 16)
      .frame(height: 48)
    }
  }
  
  @ViewBuilder
  private func makeTerms(serviceTerms: AttributedString, privacyPolicy: AttributedString) -> some View {
    Text("가입을 진행할 경우\n \(serviceTerms) 및 \(privacyPolicy)에 동의한 것으로 간주합니다. ")
      .font(.regular(size: ._12))
      .foregroundStyle(Color.bkColor(.gray600))
      .padding(.top, 16)
      .lineLimit(2)
      .multilineTextAlignment(.center)
      .environment(\.openURL, OpenURLAction { url in
        return .systemAction
      })
  }
  
  private func makeTermsText(_ text: String, url: String) -> AttributedString {
    var attributedString = AttributedString(text)
    attributedString.foregroundColor = .bkColor(.gray600)
    attributedString.font = .regular(size: ._12)
    attributedString.underlineStyle = .single
    attributedString.link = URL(string: url)
    return attributedString
  }
}
