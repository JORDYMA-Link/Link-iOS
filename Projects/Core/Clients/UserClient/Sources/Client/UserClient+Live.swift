//
//  UserClient+Live.swift
//  UserClient
//
//  Created by 문정호 on 8/25/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKNetwork

import Dependencies

extension UserClient: DependencyKey {
  public static var liveValue: UserClient {
    let userProvider = Provider<UserEndpoint>()

    return Self(
      getUserProfile: {
        let responseDTO: UserProfileResponse = try await userProvider.request(.getUserProfile, modelType: UserProfileResponse.self)
        return responseDTO.toDomain()
      },
      requestUserProfile: { nickname in
        let responseDTO: UserProfileResponse = try await userProvider.request(.patchUserProfile(nickName: nickname), modelType: UserProfileResponse.self)
        return responseDTO.toDomain()
      },
      putFcmPushToken: { pushToken in
        return try await userProvider.requestPlain(.putFcmPushToken(pushToken: pushToken))
      },
      postOnboarding: { jobField, birthYear, gender in
        return try await userProvider.requestPlain(.postOnboarding(jobField: jobField, birthYear: birthYear, gender: gender))
      }
    )
  }
}
