//
//  OnboardingSubjectView.swift
//  Blink
//
//  Created by kyuchul on 6/3/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

public struct OnboardingSubjectView: View {
  @Bindable var store: StoreOf<OnboardingSubjectFeature>
  
  public init(store: StoreOf<OnboardingSubjectFeature>) {
    self.store = store
  }
  
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
  
  public var body: some View {
    VStack(spacing: 0) {
      makeNavigationBar()
      
      makeTitle()
        .padding(.top, 28)
      
      makeSubjectGrid()
        .padding(EdgeInsets(top: 24, leading: 12, bottom: 0, trailing: 12))
      
      Spacer()
      
      makeConfirmButton()
    }
    .toolbar(.hidden, for: .navigationBar)
    .padding(EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16))
  }
  
  @ViewBuilder
  private func makeNavigationBar() -> some View {
    HStack {
      Spacer()
      
      Text("건너뛰기")
        .font(.semiBold(size: ._14))
        .foregroundStyle(Color.bkColor(.gray600))
        .onTapGesture {
          store.send(.skipButtonTapped)
        }
    }
    .frame(height: 44)
  }
  
  @ViewBuilder
  private func makeTitle() -> some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack {
        Text("주로 어떤 주제를 아카이빙 하시나요?")
          .font(.semiBold(size: ._24))
          .foregroundStyle(Color.bkColor(.gray900))
          .lineLimit(1)
          .minimumScaleFactor(0.5)
        
        Spacer()
      }
     
      HStack {
        Text("3개를 선택해주시면 해당 폴더를 미리 만들어드릴게요!")
          .font(.regular(size: ._14))
          .foregroundStyle(Color.bkColor(.gray700))
        
        Spacer()
      }
    }
    .frame(alignment: .topLeading)
  }
  
  @ViewBuilder
  private func makeSubjectGrid() -> some View {
    let gridItem = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12), GridItem(.flexible())]
    
    LazyVGrid(columns: gridItem, spacing: 16) {
      ForEach(subjects, id: \.1) { item in
        makeSubjectCell(emoji: item.0, title: item.1, isSelected: store.subjects.contains(item.1))
          .onTapGesture {
            store.send(.selectSubject(item.1))
          }
      }
    }
  }
  
  @ViewBuilder
  private func makeSubjectCell(emoji: String, title: String, isSelected: Bool) -> some View {
    let lineHeight = UIFont.regular(size: ._16).lineHeight
    
    ZStack {
      Color(.bkColor(isSelected ? .main300 : .gray300))
      
      VStack(spacing: 0) {
        Text(emoji)
          .font(.regular(size: ._16))
          .padding(.vertical, (24 - lineHeight) / 2)
        
        Text(title)
          .font(.regular(size: ._16))
          .foregroundStyle(Color.bkColor(isSelected ? .white : .black))
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
      store.send(.confirmButtonTapped)
    } label: {
      ZStack {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
          .fill(Color.bkColor(store.subjects.isEmpty ? .gray500 : .main300))
          .frame(maxWidth: .infinity)
        
        Text("확인")
          .font(.semiBold(size: ._16))
          .foregroundStyle(Color.bkColor(store.subjects.isEmpty ? .gray600 : .white))
          .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
      }
      .frame(height: 52)
    }
    .disabled(store.subjects.isEmpty)
  }
}
