//
//  SettingFeature.swift
//  Features
//
//  Created by 문정호 on 8/15/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import ComposableArchitecture

@Reducer
public struct SettingFeature {
  @ObservableState
  public struct State: Equatable {
    var nickname = "블링크"
    var userEmail: String = ""
    var showEditNicknameSheet: Bool = false
    var showWithdrawModal: Bool = false
    var showLogoutConfirmModal: Bool = false
    var confirmWithdrawState: Bool = false
    var targetNickname: String = ""
  }
  
  public enum Action: BindableAction {
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
    
    case binding(BindingAction<State>)
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      case .tappedNicknameEdit:
        state.showEditNicknameSheet = true
        
      case .toggleLogOut:
        state.showLogoutConfirmModal.toggle()
        
      case .tappedWithdrawCell:
        state.showWithdrawModal = true
        
      case .toggleConfirmWithdrawNotice:
        state.showWithdrawModal.toggle()
        
      case .cancelCompletedEditingNickname:
        state.showEditNicknameSheet = false
        
      default:
        break
      }
      return .none
    }
  }
  
}
