//
//  LoginView.swift
//  Blink
//
//  Created by kyuchul on 5/31/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct LoginView: View {
    @Environment(\.openURL) var openURL
    
    @State private var pushToOnboarding = false
    private var attributedString: AttributedString {
        let string = "서비스 약관"
        var attributedString = AttributedString(string)
        attributedString.foregroundColor = .bkColor(.gray600)
        attributedString.font = .regular(size: ._12)
        attributedString.underlineStyle = .single
        attributedString.link = URL(string: "https://www.naver.com")
        return attributedString
    }
    private var aattributedString: AttributedString {
        let string = "개인정보 처리방침"
        var attributedString = AttributedString(string)
        attributedString.foregroundColor = .bkColor(.gray600)
        attributedString.font = .regular(size: ._12)
        attributedString.underlineStyle = .single
        attributedString.link = URL(string: "https://www.kakao.com")
        return attributedString
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                
                VStack(alignment: .center, spacing: 0) {
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.bkColor(.main300))
                            .frame(width: 135, height: 135)
                        
                        BKIcon(image: CommonFeatureAsset.Images.logoWhite.swiftUIImage, color: .white, size: CGSize(width: 64, height: 70))
                    }
                    
                    Text("눈 깜짝할 새 저장되는\nAI 링크 아카이빙, 블링크")
                        .font(.semiBold(size: ._20))
                        .foregroundStyle(Color.bkColor(.gray900))
                        .multilineTextAlignment(.center)
                        .padding(.top, 16)
                        .frame(alignment: .center)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Button {
                            pushToOnboarding = true
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.bkColor(.kakaoYellow))
                                    .frame(maxWidth: .infinity)
                                
                                HStack(spacing: 4) {
                                    BKIcon(image: CommonFeatureAsset.Images.icokakao.swiftUIImage, color: .bkColor(.gray900), size: CGSize(width: 20, height: 20))
                                    
                                    Text("카카오톡으로 시작하기")
                                        .font(.semiBold(size: ._16))
                                        .foregroundStyle(Color.bkColor(.gray900))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                            }
                            .padding(.top)
                            .padding(.horizontal, 16)
                            .frame(height: 48)
                        }
                        
                        Button {
                            print("애플로 시작")
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.bkColor(.black))
                                    .frame(maxWidth: .infinity)
                                
                                HStack(spacing: 4) {
                                    BKIcon(image: CommonFeatureAsset.Images.icoapple.swiftUIImage, color: .bkColor(.white), size: CGSize(width: 20, height: 20))
                                    
                                    Text("Apple로 시작하기")
                                        .font(.semiBold(size: ._16))
                                        .foregroundStyle(Color.bkColor(.white))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                            }
                            .padding(.top)
                            .padding(.horizontal, 16)
                            .frame(height: 48)
                        }
                        
                        Text("가입을 진행할 경우\n \(attributedString) 및 \(aattributedString)에 동의한 것으로 간주합니다. ")
                            .font(.regular(size: ._12))
                            .foregroundStyle(Color.bkColor(.gray600))
                            .padding(.top, 16)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .environment(\.openURL, OpenURLAction { url in
                                print("\n---> Text: \(url)")
                                return .systemAction
                            })
                    }
                }
            }
            .navigationDestination(isPresented: $pushToOnboarding) {
                OnboardingSubjectView()
            }
        }
    }
}

#Preview {
    LoginView()
}
