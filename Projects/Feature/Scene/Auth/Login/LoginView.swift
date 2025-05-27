//
//  LoginView.swift
//  Blink
//
//  Created by kyuchul on 5/31/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import Common
import CommonFeature
import Models

import ComposableArchitecture

public struct LoginView: View {
  @Perception.Bindable var store: StoreOf<LoginFeature>
  @State private var pushToOnboarding = false
  
  public init(store: StoreOf<LoginFeature>) {
    self.store = store
  }
  
  public var body: some View {
    NavigationStack {
      WithPerceptionTracking {
        VStack(alignment: .center, spacing: 0) {
          Spacer()
          Spacer()
          
          logo
          title
          
          Spacer()
          Spacer()
          Spacer()
          
          VStack(spacing: 12) {
            SocialLoginButton(
              socialType: .kakao,
              action: {
                HapticFeedbackManager.shared.impact(style: .light)
                store.send(.kakaoLoginButtonTapped)
              }
            )
            
            SocialLoginButton(
              socialType: .apple,
              action: {
                HapticFeedbackManager.shared.impact(style: .light)
                store.send(.appleLoginButtonTapped)
              }
            )
            
            SocialLoginButton(
              socialType: .google,
              action: {
                HapticFeedbackManager.shared.impact(style: .light)
                store.send(.googleLoginButtonTapped)
              }
            )
            
            makeTerms(
              serviceTerms:makeTermsText("서비스 약관", url: URLLiteral.termOfUse.url),
              privacyPolicy: makeTermsText("개인정보 처리방침", url: URLLiteral.privacy.url)
            )
          }
        }
        .background(.white)
        .if(store.isLoading) { view in
          view.overlay {
            LoginIndicator()
          }
        }
      }
    }
  }
  
  private var logo: some View {
    CommonFeature.Images.icoAppLogo
      .resizable()
      .scaledToFit()
      .frame(width: 100, height: 100)
  }
  
  private var title: some View {
    VStack(alignment: .center, spacing: 0) {
      BKText(
        text: "혹시 필요할까? 일단 저장해!",
        font: .regular,
        size: ._18,
        lineHeight: 26,
        color: .bkColor(.main900)
      )
      
      BKText(
        text: "정보 욕심러의 필수 앱",
        font: .semiBold,
        size: ._24,
        lineHeight: 34,
        color: .bkColor(.main900)
      )
    }
    .frame(maxWidth: .infinity)
    .padding(.top, 22)
  }
  
  @ViewBuilder
  private func makeTerms(serviceTerms: AttributedString, privacyPolicy: AttributedString) -> some View {
    Text("가입을 진행할 경우\n \(serviceTerms) 및 \(privacyPolicy)에 동의한 것으로 간주합니다. ")
      .font(.regular(size: ._12))
      .foregroundStyle(Color.bkColor(.gray600))
      .padding(.top, 4)
      .padding(.bottom, 16)
      .lineLimit(2)
      .multilineTextAlignment(.center)
      .environment(\.openURL, OpenURLAction { url in
        return .systemAction
      })
  }
  
  private func makeTermsText(_ text: String, url: URL?) -> AttributedString {
    var attributedString = AttributedString(text)
    attributedString.foregroundColor = .bkColor(.gray600)
    attributedString.font = .regular(size: ._12)
    attributedString.underlineStyle = .single
    attributedString.link = url
    return attributedString
  }
}

private struct SocialLoginButton: View {
  private let socialType: SocialLoginInfo.Socialtype
  private let action: () -> Void
  
  init(
    socialType: SocialLoginInfo.Socialtype,
    action: @escaping () -> Void
  ) {
    self.socialType = socialType
    self.action = action
  }
  
  var body: some View {
    Button(action: action) {
      ZStack {
        backgroundView
        
        HStack(alignment: .center) {
          buttonImage
            .resizable()
            .scaledToFill()
            .frame(width: 20, height: 20)
          
          Text(buttonTitle)
            .font(.semiBold(size: ._16))
            .foregroundStyle(titleColor)
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
      }
      .padding(.top)
      .padding(.horizontal, 16)
      .frame(height: 52)
    }
  }
  
  @ViewBuilder
  private var backgroundView: some View {
    switch socialType {
    case .kakao, .apple:
      RoundedRectangle(cornerRadius: 10, style: .continuous)
        .fill(backgroundColor)
        .frame(maxWidth: .infinity)
    case .google:
      RoundedRectangle(cornerRadius: 10, style: .continuous)
        .stroke(Color.bkColor(.gray500), lineWidth: 1)
        .frame(maxWidth: .infinity)
    }
  }
  
  private var backgroundColor: Color {
    switch socialType {
    case .kakao:
      return .bkColor(.kakaoYellow)
    case .apple:
      return .bkColor(.black)
    case .google:
      return .clear
    }
  }
  
  private var titleColor: Color {
    switch socialType {
    case .kakao, .google:
      return .bkColor(.gray900)
    case .apple:
      return .bkColor(.white)
    }
  }
  
  private var buttonTitle: String {
    switch socialType {
    case .kakao:
      return "카카오톡으로 시작하기"
    case .apple:
      return "Apple로 시작하기"
    case .google:
      return "Google로 시작하기"
    }
  }
  
  private var buttonImage: Image {
    switch socialType {
    case .kakao:
      return CommonFeature.Images.icokakao
    case .apple:
      return CommonFeature.Images.icoapple
    case .google:
      return CommonFeature.Images.icoGoogle
    }
  }
}

private struct LoginIndicator: View {
  var body: some View {
    VStack {
      Spacer()
      BKLoadingIndicator()
      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    .ignoresSafeArea()
  }
}
