//
//  UserClient.swift
//  Models
//
//  Created by 문정호 on 8/25/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import Dependencies

public struct UserClient {
  public var getUserProfile: @Sendable () async throws -> Setting
  public var requestUserProfile: @Sendable (_ nickname: String) async throws -> Setting
  public var putFcmPushToken: @Sendable (_ pushToken: String) async throws -> Void
}

extension UserClient: DependencyKey {
  public static var liveValue: UserClient {
    let settingClient = Provider<UserEndpoint>()
    
    return Self(
      getUserProfile: {
        let responseDTO: UserProfileResponse = try await settingClient.request(.getUserProfile, modelType: UserProfileResponse.self)
        return responseDTO.toDomain()
      },
      requestUserProfile: { nickname in
        let responseDTO: UserProfileResponse = try await settingClient.request(.patchUserProfile(nickName: nickname), modelType: UserProfileResponse.self)
        return responseDTO.toDomain()
      },
      putFcmPushToken: { pushToken in
        return try await settingClient.requestPlain(.putFcmPushToken(pushToken: pushToken))
      }
    )
  }
}

public extension DependencyValues {
    var userClient: UserClient {
        get { self[UserClient.self] }
        set { self[UserClient.self] = newValue }
    }
}

