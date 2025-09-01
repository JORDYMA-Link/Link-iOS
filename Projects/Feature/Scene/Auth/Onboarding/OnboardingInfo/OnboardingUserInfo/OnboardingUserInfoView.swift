//
//  OnboardingUserInfoView.swift
//  Feature
//
//  Created by 김규철 on 9/1/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import SwiftUI

import CommonFeature

import ComposableArchitecture

public struct OnboardingUserInfoView: View {
  @Perception.Bindable var store: StoreOf<OnboardingUserInfoFeature>
  
  public init(store: StoreOf<OnboardingUserInfoFeature>) {
    self.store = store
  }
  
  public var body: some View {
    WithPerceptionTracking {
      NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
        contentView
      } destination: { store in
        switch store.case {
        case .subject(let store):
          OnboardingSubjectView(store: store)
        }
      }
    }
  }
  
  private var contentView: some View {
    VStack(spacing: 0) {
      titleView
      sectionView(title: "직무 분야", content: jobFieldSection)
      sectionView(title: "연령대", content: ageGroupSection)
      sectionView(title: "성별", content: genderSection, isLast: true)
      Spacer()
      nextButton
    }
    .padding(.horizontal, 16)
    .toolbar(.hidden, for: .navigationBar)
    .onAppear {
      store.send(.onAppear)
    }
  }
  
  private var titleView: some View {
    HStack {
      Text("간단한 정보를 입력해 주세요")
        .font(.semiBold(size: ._24))
        .foregroundStyle(Color.bkColor(.gray900))
        .lineLimit(1)
      
      Spacer()
    }
    .frame(alignment: .topLeading)
    .padding(.top, 24)
    .padding(.bottom, 32)
  }
  
  private var nextButton: some View {
    BKRoundedButton(
      title: "다음",
      isDisabled: !store.isFormValid,
      confirmAction: { store.send(.nextButtonTapped) }
    )
    .padding(.bottom, 16)
  }
}

extension OnboardingUserInfoView {
  private func sectionView<Content: View>(
    title: String,
    content: Content,
    isLast: Bool = false
  ) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      sectionHeaderView(title: title)
      content
    }
    .padding(.bottom, isLast ? 0 : 32)
  }
  
  private func sectionHeaderView(title: String) -> some View {
    HStack {
      Text(title)
        .font(.semiBold(size: ._18))
        .foregroundStyle(Color.bkColor(.black))
      
      Spacer()
    }
  }
  
  private var jobFieldSection: some View {
    OnboardingUserInfoFlowLayout(verticalSpacing: 8, horizontalSpacing: 6) {
      ForEach(store.jobFields, id: \.self) { jobField in
        WithPerceptionTracking {
          sectionItem(
            title: jobField,
            isSelected: store.selectedJobField == jobField
          )
          .onTapGesture {
            store.send(.jobFieldItemTapped(jobField), animation: .spring)
          }
        }
      }
    }
    .fixedSize(horizontal: false, vertical: true)
  }
  
  private var ageGroupSection: some View {
    OnboardingUserInfoFlowLayout(verticalSpacing: 8, horizontalSpacing: 6) {
      ForEach(store.ageGroups, id: \.self) { ageGroup in
        WithPerceptionTracking {
          sectionItem(
            title: ageGroup,
            isSelected: store.selectedAgeGroup == ageGroup
          )
          .onTapGesture {
            store.send(.ageGroupItemTapped(ageGroup), animation: .spring)
          }
        }
      }
    }
    .fixedSize(horizontal: false, vertical: true)
  }
  
  private var genderSection: some View {
    OnboardingUserInfoFlowLayout(verticalSpacing: 8, horizontalSpacing: 6) {
      ForEach(store.genders, id: \.self) { gender in
        WithPerceptionTracking {
          sectionItem(
            title: gender,
            isSelected: store.selectedGender == gender
          )
          .onTapGesture {
            store.send(.genderItemTapped(gender), animation: .spring)
          }
        }
      }
    }
    .fixedSize(horizontal: false, vertical: true)
  }
  
  private func sectionItem(title: String, isSelected: Bool) -> some View {
    Text(title)
      .font(.regular(size: ._14))
      .foregroundStyle(Color.bkColor(isSelected ? .main300 : .gray900))
      .padding(.vertical, 14)
      .padding(.horizontal, 16)
      .background(
        Capsule()
          .fill(Color.bkColor(isSelected ? .main200 : .white))
      )
      .overlay {
        Capsule()
          .stroke(Color.bkColor(isSelected ? .main400 : .gray500), lineWidth: 1)
      }
  }
}
