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
        case unRegist
    }
    
    enum State {
        case none
    }
    
    
    @Published var state: State
    @Published var nickname: String
    @Published var userEmail: String
    @Published var showEditNicknameSheet: Bool = false
    
    init(state: State, nickname: String, userEmail: String) {
        self.state = state
        self.nickname = nickname
        self.userEmail = userEmail
    }
    
    
    func action(_ action: Action) {
        switch action {
        case .tappedNicknameEdit:
            showEditNicknameSheet.toggle()
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
            print("")
        case .unRegist:
            print("")
        }
    }
    
    
    
    
    
}
