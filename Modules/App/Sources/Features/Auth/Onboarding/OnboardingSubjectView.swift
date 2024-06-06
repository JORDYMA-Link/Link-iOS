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
    private let subjects = [
        ("💰", "경제"),
        ("🖌️", "기획"),
        ("💻", "개발"),
        ("📚", "독서"),
        ("🐶", "동물"),
        ("🖼", "디자인"),
        ("🎀", "아이돌"),
        ("✈️", "여행"),
        ("💡", "영감"),
        ("👚", "옷"),
        ("🍽️", "요리"),
        ("🩻", "의료"),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            makeTitle()
            
            makeSubjectGrid()
                .padding(EdgeInsets(top: 24, leading: 12, bottom: 0, trailing: 12))
            
            Spacer()
            
            makeConfirmButton()
        }
        .padding(EdgeInsets(top: 28, leading: 16, bottom: 16, trailing: 16))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                makeToolbarItem()
            }
        }
    }
    
    @ViewBuilder
    private func makeToolbarItem() -> some View {
        Text("건너뛰기")
            .font(.semiBold(size: ._14))
            .foregroundStyle(Color.bkColor(.gray600))
            .onTapGesture {
                print("go Home")
            }
    }
    
    @ViewBuilder
    private func makeTitle() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("주로 어떤 주제를 아카이빙 하시나요?")
                .font(.semiBold(size: ._24))
                .foregroundStyle(Color.bkColor(.gray900))
            
            Text("3개를 선택해주시면 해당 폴더를 미리 만들어드릴게요!")
                .font(.regular(size: ._14))
                .foregroundStyle(Color.bkColor(.gray700))
        }
    }
    
    @ViewBuilder
    private func makeSubjectGrid() -> some View {
        let gridItem = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12), GridItem(.flexible())]
        
        LazyVGrid(columns: gridItem, spacing: 16) {
            ForEach(subjects, id: \.1) { item in
                makeSubjectCell(emoji: item.0, title: item.1)
                    .onTapGesture {
                        print("Tap Subject")
                    }
            }
        }
    }
    
    @ViewBuilder
    private func makeSubjectCell(emoji: String, title: String) -> some View {
        let lineHeight = UIFont.regular(size: ._16).lineHeight
        
        ZStack {
            Color(.bkColor(.gray300))
            
            VStack(spacing: 0) {
                Text(emoji)
                    .font(.regular(size: ._16))
                    .padding(.vertical, (24 - lineHeight) / 2)
                
                Text(title)
                    .font(.regular(size: ._16))
                    .padding(.vertical, (24 - lineHeight) / 2)
            }
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        }
        .frame(height: 84)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder
    private func makeConfirmButton() -> some View {
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
                    .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            }
            .frame(height: 52)
        }
    }
}
