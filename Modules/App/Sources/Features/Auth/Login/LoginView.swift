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

struct LoginView: View {
    @Perception.Bindable var store: StoreOf<LoginFeature>
    
    @State private var pushToOnboarding = false
    
    var body: some View {
        NavigationStack {
            WithPerceptionTracking {
                ZStack {
                    Color.white
                    
                    VStack(alignment: .center, spacing: 0) {
                        Spacer()
                        
                        makeLogo()
                        makeTitle()
                        
                        Spacer()
                        
                        VStack(spacing: 12) {
                            makeLoginButton(action: {
                                pushToOnboarding = true
                            }, backgroundColor: .bkColor(.kakaoYellow), title: "카카오톡으로 시작하기", titleColor: .bkColor(.gray900), buttonImage: CommonFeatureAsset.Images.icokakao.swiftUIImage, buttonImageColor: .bkColor(.gray900))
                            
                            makeLoginButton(action: {
                                pushToOnboarding = true
                            }, backgroundColor: .bkColor(.black), title: "Apple로 시작하기", titleColor: .bkColor(.white), buttonImage: CommonFeatureAsset.Images.icoapple.swiftUIImage, buttonImageColor: .bkColor(.white))
                            
                            makeTerms(
                                serviceTerms:makeTermsText("서비스 약관", url: "https://upbit.com/home"),
                                privacyPolicy: makeTermsText("개인정보 처리방침", url: "https://www.bithumb.com/react")
                            )
                        }
                    }
                }
                .navigationDestination(isPresented: $pushToOnboarding) {
                    OnboardingSubjectView(store: .init(initialState: OnboardingSubjectFeature.State()) {
                        OnboardingSubjectFeature()
                    })
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
            
            BKIcon(image: CommonFeatureAsset.Images.logoWhite.swiftUIImage, color: .white, size: CGSize(width: 64, height: 70))
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
