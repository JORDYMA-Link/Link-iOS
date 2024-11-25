//
//  SettingFeature.swift
//  Features
//
//  Created by 문정호 on 8/15/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models
import Services

import ComposableArchitecture

@Reducer
public struct SettingFeature {
  @ObservableState
  public struct State: Equatable {
    var nickname: String = "블링크"
    var validationNoticeMessage: String = ""
    var currentAppVersion: String = Bundle.currentAppVersion
    var latestAppVersion: String = "Unknown"
    var showEditNicknameSheet: Bool = false
    var showWithdrawModal: Bool = false
    var showLogoutConfirmModal: Bool = false
    var isConfirmedWithdrawWarning: Bool = false
    var targetNickname: String = ""
    var targetNicknameValidation: Bool = true
    
    @Presents var noticeContent: NoticeFeature.State?
  }
  
  public enum Action: BindableAction {
    //action
    case requestSettingInfo
    case changeNickName(targetNickname: String)
    case fetchLatestVersion(version: String?)
    
    //user Action
    case tappedNaviBackButton
    case tappedNicknameEdit
    case tappedNotice
    case tappedPersonal
    case tappedService
    case versionInfo
    case tappedServiceInfo
    case tappedLogOut
    case tappedWithdrawCell
    case signoutButtonTapped
    case changeConfirmWithdrawModal
    case confirmedWithdrawWarning
    case tappedCompletedEditingNickname
    case cancelEditingNickname
    
    case postLogout
    case postSignout
    
    case setDeleteKeychain
    case setDeleteUserDefaults
    
    //binding
    case binding(BindingAction<State>)
    case noticeContent(PresentationAction<NoticeFeature.Action>)
    
    public enum Delegate {
      case logout
      case signout
    }
    case delegate(Delegate)
  }
  
  
  private enum NicknameValidationNotice {
    case notAllowOthreLanguage
    case notAllowTextSymbol
    case notAllowSpace
    case notAllowOverTenChar
    
    var noticeMessage: String {
      switch self {
      case .notAllowOthreLanguage:
        return "영문 사용은 허용되지 않습니다."
      case .notAllowTextSymbol:
        return "이모지는 허용되지 않습니다"
      case .notAllowSpace:
        return "공백은 허용되지 않습니다"
      case .notAllowOverTenChar:
        return "10글자 이상은 허용되지 않습니다."
      }
    }
  }
  
  //MARK: - Dependency
  @Dependency(\.dismiss) private var dismiss
  @Dependency(\.alertClient) private var alertClient
  @Dependency(\.userDefaultsClient) private var userDefaultsClient
  @Dependency(\.keychainClient) private var keychainClient
  @Dependency(\.userClient) private var userClient
  @Dependency(\.authClient) private var authClient

  
  private enum ThrottleId {
    case logoutButton
  }
  
  public var body: some ReducerOf<Self> {
    BindingReducer()
    
    Reduce { state, action in
      switch action {
      //MARK: Programical Action
      case .requestSettingInfo:
        return .run { send in
          let response = try await userClient.getUserProfile()
          await send(.changeNickName(targetNickname: response.nickname))
          let latestVersion = try await fetchAppVersion()
          await send(.fetchLatestVersion(version: latestVersion))
        }
        
      case let .changeNickName(targetNickname):
        state.nickname = targetNickname
        state.targetNickname = ""
        return .none
        
      case let .fetchLatestVersion(version):
        state.latestAppVersion = version ?? state.currentAppVersion
        return .none
        

      //User Action
      case .tappedNaviBackButton:
        return .run { _ in await self.dismiss() }

      case .tappedNicknameEdit:
        state.showEditNicknameSheet = true
        return .none
        
      case .tappedLogOut:
        return .run { send in
          await alertClient.present(.init(
            title: "로그아웃",
            description: "정말 로그아웃 하시겠어요?",
            buttonType: .doubleButton(left: "아니오", right: "로그아웃"),
            rightButtonAction: { await send(.postLogout) })
          )
        }
        .throttle(id: ThrottleId.logoutButton, for: .seconds(1), scheduler: DispatchQueue.main, latest: false)
        
      case .tappedWithdrawCell:
        state.showWithdrawModal = true
        return .none
        
      case .signoutButtonTapped:
        return .send(.postSignout)
        
      case .tappedNotice:
        state.noticeContent = .init()
        return .none
        
      case .changeConfirmWithdrawModal:
        state.showWithdrawModal.toggle()
        return .none
        
      case .confirmedWithdrawWarning:
        state.isConfirmedWithdrawWarning.toggle()
        return .none
        
      case .cancelEditingNickname:
        state.targetNickname = ""
        return .none
        
      case .tappedCompletedEditingNickname:
        guard state.targetNicknameValidation, !state.targetNickname.isEmpty else { return .none }
        state.showEditNicknameSheet = false
        return .run { [targetNickName = state.targetNickname] send in
          let response = try await userClient.requestUserProfile(targetNickName)
          await send(.changeNickName(targetNickname: response.nickname))
        }
        
      case .postLogout:
        return .run(
          operation: { send in
            let refreshToken = keychainClient.read(.refreshToken)
            
            try await authClient.logout(refreshToken)
            
            await send(.setDeleteKeychain)
            await send(.delegate(.logout))
          },
          catch : { error, send in
            print(error)
          }
        )
        
      case .postSignout:
        return .run(
          operation: { send in
            let refreshToken = keychainClient.read(.refreshToken)
            
            try await authClient.signout(refreshToken)
            
            await send(.setDeleteKeychain)
            await send(.setDeleteUserDefaults)
            await send(.delegate(.signout))
          },
          catch : { error, send in
            print(error)
          }
        )
        
      case .setDeleteKeychain:
        return .run { send in
          try await keychainClient.delete(.accessToken)
          try await keychainClient.delete(.refreshToken)
        }
        
      case .setDeleteUserDefaults:
        userDefaultsClient.reset()
        return .none
        
      case .binding(\.targetNickname):
        let target = state.targetNickname
        
        func setValidationResult(isValid: Bool, message: String) {
          state.targetNicknameValidation = isValid
          state.validationNoticeMessage = message
        }
        
        if target.containsWhitespace {
          setValidationResult(isValid: false, message: NicknameValidationNotice.notAllowSpace.noticeMessage)
        } else if target.containsEmoji {
          setValidationResult(isValid: false, message: NicknameValidationNotice.notAllowTextSymbol.noticeMessage)
        } else if target.containsOtherLanguage {
          setValidationResult(isValid: false, message: NicknameValidationNotice.notAllowOthreLanguage.noticeMessage)
        } else if target.count >= 10 {
          setValidationResult(isValid: false, message: NicknameValidationNotice.notAllowOverTenChar.noticeMessage)
        } else {
          setValidationResult(isValid: true, message: "")
        }
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$noticeContent, action: \.noticeContent) {
      NoticeFeature()
    }
  }
}

extension SettingFeature {
  private func fetchAppVersion() async throws -> String? {
    guard let bundleId = Bundle.main.bundleIdentifier else { throw VersionCheckError.fetchFailed }
    let urlString = "https://itunes.apple.com/lookup?bundleId=\(bundleId)"
    
    guard let url = URL(string: urlString) else { throw VersionCheckError.fetchFailed }
    
    let (data, _) = try await URLSession.shared.data(from: url)
    
    let response = try JSONDecoder().decode(AppVersionResponse.self, from: data)
    
    return response.results.first?.version
  }
}
