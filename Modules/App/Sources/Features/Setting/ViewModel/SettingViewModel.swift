//
//  SettingViewModel.swift
//  Blink
//
//  Created by kyuchul on 4/29/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation
import CommonFeature

final class SettingViewModel: ViewModelable {
    
    enum Action {
        case tappedNicknameEdit
        case tappedNotice
        case tappedPersonal
        case tappedService
        case versionInfo
        case tappedServiceInfo
        case tappedLogout
        case tappedWithdrawCell
        case tappedConfirmWithdrawNotice
        case tappedCompletedEditingNickname
    }
    
    enum State {
        case none
        case EditingNickname
        case showWithdrawModal
        case needConfirmWithdrawNotice
        case confirmedWithdrawNotice
        case showLogoutModal
    }
    
    
    @Published var state: State
    @Published var nickname: String
    @Published var userEmail: String
    @Published var showEditNicknameSheet: Bool = false
    @Published var showWithdrawModal: Bool = false
    @Published var showLogoutConfirmModal: Bool = false
    @Published var confirmWithdrawState: Bool = false
    @Published var targetNickname: String = ""
    
    init(state: State, nickname: String, userEmail: String) {
        self.state = state
        self.nickname = nickname
        self.userEmail = userEmail
    }
    
    
    func action(_ action: Action) {
        switch action {
        case .tappedNicknameEdit:
            willEditNickname()
        case .tappedNotice:
            print("")
        case .tappedPersonal:
            print("")
        case .tappedService:
            print("")
        case .versionInfo:
            print("")
        case .tappedServiceInfo:
            print("")
        case .tappedLogout:
            tappedLogout()
        case .tappedWithdrawCell:
            tappedWithdrawCell()
        case .tappedConfirmWithdrawNotice:
            willChangeConfirmState()
        case .tappedCompletedEditingNickname:
            didEditNickname()
       
        }
    }
    
}

extension SettingViewModel {
    private func willEditNickname() {
        targetNickname = nickname
        showEditNicknameSheet.toggle()
        state = .EditingNickname
    }
    
    private func didEditNickname() {
        //서버 통신 로직 작성
        /* if 서버통신 성공 {
         
         } else {
         
         }
         */
        nickname = targetNickname
        showEditNicknameSheet.toggle()
    }
    
    private func tappedWithdrawCell() {
        showWithdrawModal = true
        state = .showWithdrawModal
    }
    
    private func tappedLogout() {
        showLogoutConfirmModal = true
        state = .showLogoutModal
    }
    
    private func willChangeConfirmState() {
        confirmWithdrawState.toggle()
        state = confirmWithdrawState ? .needConfirmWithdrawNotice : .confirmedWithdrawNotice
    }
    
}
