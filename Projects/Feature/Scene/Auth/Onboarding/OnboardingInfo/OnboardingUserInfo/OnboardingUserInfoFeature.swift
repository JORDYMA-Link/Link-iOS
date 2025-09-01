//
//  OnboardingUserInfoFeature.swift
//  Feature
//
//  Created by 김규철 on 9/1/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct OnboardingUserInfoFeature {
  @Reducer(state: .equatable)
  public enum Path {
    case subject(OnboardingSubjectFeature)
  }
  
  @ObservableState
  public struct State: Equatable {
    var path = StackState<Path.State>()
    
    var jobFields: [String] = []
    var ageGroups: [String] = []
    var genders: [String] = []
    
    var selectedJobField: String? = nil
    var selectedAgeGroup: String? = nil
    var selectedGender: String? = nil
    
    var isFormValid: Bool {
      return selectedJobField != nil &&
      selectedAgeGroup != nil &&
      selectedGender != nil
    }
    
    public init() {}
  }
  
  public enum Action: BindableAction {
    case binding(BindingAction<State>)
    case path(StackAction<Path.State, Path.Action>)
    
    // MARK: User Action
    case onAppear
    case jobFieldItemTapped(String)
    case ageGroupItemTapped(String)
    case genderItemTapped(String)
    case nextButtonTapped
    
    // MARK: Inner Business Action
    case load
    
    // MARK: Delegate Action
    public enum Delegate {
      case moveToMainTab
    }
    
    case delegate(Delegate)
  }
  
  public init() {}
  
  public var body: some ReducerOf<Self> {
    Reduce { state, action in
      switch action {
      case .onAppear:
        return .run { send in
          try? await Task.sleep(for: .seconds(0.5))
          await send(.load, animation: .spring)
        }
        
      case let .jobFieldItemTapped(jobField):
        state.selectedJobField = jobField
        return .none
        
      case let .ageGroupItemTapped(ageGroup):
        state.selectedAgeGroup = ageGroup
        return .none
        
      case let .genderItemTapped(gender):
        state.selectedGender = gender
        return .none
        
      case .nextButtonTapped:
        guard state.isFormValid,
              let jobField = state.selectedJobField,
              let ageGroup = state.selectedAgeGroup,
              let gender = state.selectedGender else { return .none }
        
        let subjectState = OnboardingSubjectFeature.State(
          jobField: jobField,
          ageGroup: ageGroup,
          gender: gender
        )
        state.path.append(.subject(subjectState))
        return .none
                
      case .load:
        state.jobFields = [
          "개발", "기획(PM·PO)", "디자인", "마케팅/광고", "콘텐츠 기획", "영상",
          "언론", "행정", "금융/투자", "의료/보건", "연구", "교육", "학생", "기타"
        ]
        state.ageGroups = ["10대", "20대", "30대", "40대", "50대 이상"]
        state.genders = ["남성", "여성"]
        return .none
        
      case .path(.element(id: _, action: .subject(.delegate(.backButtonTapped)))):
        state.path.removeLast()
        return .none
        
      case .path(.element(id: _, action: .subject(.delegate(.skipButtonTapped)))):
        return .send(.delegate(.moveToMainTab))

      case .path(.element(id: _, action: .subject(.delegate(.confirmButtonTapped)))):
        return .send(.delegate(.moveToMainTab))
        
      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }
}
