//
//  SettingClient.swift
//  Models
//
//  Created by 문정호 on 8/25/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import Dependencies
import Moya

public struct SettingClient {
  public var getUserProfile: @Sendable () async throws -> Setting
  public var requestUserProfile: @Sendable (_ nickname: String) async throws -> Setting
}

extension SettingClient: DependencyKey {
  public static var liveValue: SettingClient {
    let settingClient = Provider<SettingEndpoint>()
    
    return Self(
      getUserProfile: {
        let responseDTO: UserProfileResponse = try await settingClient.request(.getUserProfile, modelType: UserProfileResponse.self)
        return responseDTO.toDomain()
      },
      requestUserProfile: { nickname in
        let responseDTO: UserProfileResponse = try await settingClient.request(.patchUserProfile(nickName: nickname), modelType: UserProfileResponse.self)
        return responseDTO.toDomain()
      }
    )
  }
}

public extension DependencyValues {
    var settingClient: SettingClient {
        get { self[SettingClient.self] }
        set { self[SettingClient.self] = newValue }
    }
}

