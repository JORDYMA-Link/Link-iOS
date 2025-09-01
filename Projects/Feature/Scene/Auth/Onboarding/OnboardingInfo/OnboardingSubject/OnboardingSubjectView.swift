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
  @Perception.Bindable var store: StoreOf<OnboardingSubjectFeature>
  
  public init(store: StoreOf<OnboardingSubjectFeature>) {
    self.store = store
  }
  
  private let subjects = [
    ("🖌", "기획"),
    ("🖼", "디자인"),
    ("👨‍💻", "개발"),
    ("🏦", "경제"),
    ("📈", "투자"),
    ("📖", "독서"),
    ("✈️", "여행"),
    ("📍", "맛집"),
    ("📔", "요리"),
    ("🎨", "취미"),
    ("💝", "쇼핑"),
    ("💡", "영감"),
  ]
  
  public var body: some View {
    WithPerceptionTracking {
      contentView
    }
  }
  
  private var contentView: some View {
    VStack(spacing: 0) {
      navigationBar
      titleView
      subjectGrid
      Spacer()
      confirmButton
    }
    .toolbar(.hidden, for: .navigationBar)
    .padding([.horizontal, .bottom], 16)
  }
  
  private var navigationBar: some View {
    HStack {
      Button {
        store.send(.backButtonTapped)
      } label: {
        CommonFeature.Images.icoChevronLeft
      }
      
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
  
  private var titleView: some View {
    VStack(alignment: .leading, spacing: 8) {
      HStack {
        Text("주로 어떤 주제를\n아카이빙 하시나요?")
          .font(.semiBold(size: ._24))
          .foregroundStyle(Color.bkColor(.gray900))
        
        Spacer()
      }
      
      Text("관심 주제를 선택해주시면 해당 폴더를 미리 만들어드릴게요!")
        .font(.regular(size: ._15))
        .foregroundStyle(Color.bkColor(.gray800))
    }
    .frame(maxWidth: .infinity, alignment: .topLeading)
    .padding(.vertical, 12)
  }
  
  @ViewBuilder
  private var subjectGrid: some View {
    let gridItem = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8), GridItem(.flexible())]
    
    LazyVGrid(columns: gridItem, spacing: 8) {
      ForEach(subjects, id: \.1) { item in
        subjectItem(emoji: item.0, title: item.1, isSelected: store.subjects.contains(item.1))
          .onTapGesture {
            store.send(.selectSubject(item.1), animation: .spring)
          }
      }
    }
    .padding(.vertical, 12)
  }
  
  private func subjectItem(emoji: String, title: String, isSelected: Bool) -> some View {
    VStack(alignment: .center, spacing: 8) {
      Text(emoji)
      
      Text(title)
        .font(.regular(size: ._14))
        .foregroundStyle(Color.bkColor(isSelected ? .main300 : .gray900))
    }
    .frame(maxWidth: .infinity, minHeight: 109)
    .background(
      RoundedRectangle(cornerRadius: 12)
        .fill(Color.bkColor(isSelected ? .main50 : .gray300))
    )
    .overlay {
      RoundedRectangle(cornerRadius: 12)
        .stroke(Color.bkColor(isSelected ? .main300 : .gray500), lineWidth: 1)
    }
  }
  
  private var confirmButton: some View {
    BKRoundedButton(
      title: "확인 (\(store.subjects.count)/5)",
      isDisabled: store.subjects.isEmpty,
      confirmAction: { store.send(.confirmButtonTapped) }
    )
  }
}
