//
//  SettingFeature.swift
//  Features
//
//  Created by 문정호 on 8/15/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import ComposableArchitecture

@Reducer
public struct SettingFeature {
  @ObservableState
  public struct State: Equatable {
    var nickname: String = "블링크"
    var validationNoticeMessage: String = ""
    var currentAppVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    var showEditNicknameSheet: Bool = false
    var showWithdrawModal: Bool = false
    var showLogoutConfirmModal: Bool = false
    var confirmWithdrawState: Bool = false
    var targetNickname: String = ""
    var targetNicknameValidation: Bool = true
  }
  
  public enum Action: BindableAction {
    //action
    case requestSettingInfo
    case changeNickName(targetNickname: String)
    
    //user Action
    case tappedNicknameEdit
    case tappedNotice
    case tappedPersonal
    case tappedService
    case versionInfo
    case tappedServiceInfo
    case toggleLogOut
    case tappedWithdrawCell
    case toggleConfirmWithdrawNotice
    case tappedCompletedEditingNickname
    case cancelCompletedEditingNickname
    
    //binding
    case binding(BindingAction<State>)
  }
  
  private enum NicknameValidationNotice {
    case notAllowOthreLanguage
    case notAllowTextSymbol
    case notAllowSpace
    
    var errorMessage: String {
      switch self {
      case .notAllowOthreLanguage:
        return "영문 사용은 허용되지 않습니다."
      case .notAllowTextSymbol:
        return "이모지는 허용되지 않습니다"
      case .notAllowSpace:
        return "공백은 허용되지 않습니다"
      }
    }
  }
  
  
  //MARK: - Dependency
  @Dependency(\.settingClient) private var settingClient
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .requestSettingInfo:
        return .run { send in
          let response = try await settingClient.getUserProfile()
          await send(.changeNickName(targetNickname: response.nickname))
        }
        
      case .tappedNicknameEdit:
        state.showEditNicknameSheet = true
        return .none
        
      case .toggleLogOut:
        state.showLogoutConfirmModal.toggle()
        
      case .tappedWithdrawCell:
        state.showWithdrawModal = true
        
      case .toggleConfirmWithdrawNotice:
        state.showWithdrawModal.toggle()
        
      case .cancelCompletedEditingNickname:
        state.showEditNicknameSheet = false
        
      case .tappedCompletedEditingNickname:
        guard state.targetNicknameValidation, !state.targetNickname.isEmpty else { return .none }
        state.showEditNicknameSheet = false
        return .run { [targetNickName = state.targetNickname] send in
          let response = try await settingClient.requestUserProfile(targetNickName)
          await send(.changeNickName(targetNickname: response.nickname))
        }
        
      case let .changeNickName(targetNickname):
        state.nickname = targetNickname
        state.targetNickname = ""
        
      case .binding(\.targetNickname):
        let target = state.targetNickname
        
        func setValidationResult(isValid: Bool, message: String) {
          state.targetNicknameValidation = isValid
          state.validationNoticeMessage = message
        }
        
        if target.containsWhitespace {
          setValidationResult(isValid: false, message: NicknameValidationNotice.notAllowSpace.errorMessage)
        } else if target.containsEmoji {
          setValidationResult(isValid: false, message: NicknameValidationNotice.notAllowTextSymbol.errorMessage)
        } else if target.containsOtherLanguage {
          setValidationResult(isValid: false, message: NicknameValidationNotice.notAllowOthreLanguage.errorMessage)
        } else {
          setValidationResult(isValid: true, message: "")
        }
        
      default:
        break
      }
      return .none
    }
  }
}
