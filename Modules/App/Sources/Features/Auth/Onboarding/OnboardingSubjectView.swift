//
//  OnboardingSubjectView.swift
//  Blink
//
//  Created by kyuchul on 6/3/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

struct OnboardingSubjectView: View {
    private let items = [
        ("😀", "경제"),
        ("🍎", "기획"),
        ("🚗", "개발"),
        ("🌟", "독서"),
        ("📚", "동물"),
        ("🎵", "디자인"),
        ("🏀", "아이돌"),
        ("🏖", "여행"),
        ("✈️", "영감"),
        ("🎂", "옷"),
        ("🎂", "요리"),
        ("🎂", "재료"),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("주로 어떤 주제를 아카이빙 하시나요?")
                    .font(.semiBold(size: ._24))
                    .foregroundStyle(Color.bkColor(.gray900))
                
                Text("3개를 선택해주시면 해당 폴더를 미리 만들어드릴게요!")
                    .font(.semiBold(size: ._14))
                    .foregroundStyle(Color.bkColor(.gray700))
            }
            
            LazyVGrid(columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12), GridItem(.flexible())], spacing: 16) {
                ForEach(items, id: \.1) { item in
                    ZStack {
                        Color(.bkColor(.gray300))
                        
                        VStack {
                            Text(item.0)
                                .font(.regular(size: ._16))
                            Text(item.1)
                                .font(.regular(size: ._16))
                        }
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    }
                    .frame(height: 84)
                    .cornerRadius(10)
                }
            }
            .padding(.top, 24)
            
            Spacer()
            
            Button {
                print("확인")
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.bkColor(.gray500))
                        .frame(maxWidth: .infinity)
                    
                    Text("확인")
                        .font(.semiBold(size: ._16))
                        .foregroundStyle(Color.bkColor(.gray600))
                        .multilineTextAlignment(.center)
                        .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                }
                .frame(height: 52)
            }
        }
        .padding(EdgeInsets(top: 28, leading: 16, bottom: 16, trailing: 16))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Text("건너뛰기")
                    .font(.semiBold(size: ._14))
                    .foregroundStyle(Color.bkColor(.gray600))
                    .onTapGesture {
                        print("go Home")
                    }
            }
        }
    }
}

#Preview {
    NavigationStack {
        OnboardingSubjectView()
    }
}
