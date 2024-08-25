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
//  public var getFolders: @Sendable () async throws -> [Folder]
//  public var postFolder: @Sendable (_ name: String) async throws -> Folder
//  public var postOnboardingFolder: @Sendable (_ topics: [String]) async throws -> OnboardingFolder
//  public var deleteFolder: @Sendable (_ folderId: Int) async throws -> Void
//  public var fetchFolder: @Sendable (_ folderId: Int, _ name: String) async throws -> Folder
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
//    return Self(
//      getFolders: {
//        let responseDTO: FolderListResponse = try await folderProvider.request(.getFolders, modelType: FolderListResponse.self)
//        return responseDTO.toDomain()
//      },
//      postFolder: { name in
//        let responseDTO: FolderResponse = try await folderProvider.request(.postFolder(name: name), modelType: FolderResponse.self)
//        return responseDTO.toDomain()
//      },
//      postOnboardingFolder: { topics in
//        let responseDTO: OnboardingFolderResponse = try await folderProvider.request(.postOnboardingFolder(topics: topics), modelType: OnboardingFolderResponse.self)
//        return responseDTO.toDomain()
//      },
//      deleteFolder: { folderId in
//        return try await folderProvider.requestPlain(.deleteFolder(folderId: folderId))
//      },
//      fetchFolder: { folderId, name in
//        let responseDTO: FolderResponse = try await folderProvider.request(.fetchFolder(folderId: folderId, name: name), modelType: FolderResponse.self)
//        return responseDTO.toDomain()
//      }
//    )
  }
}

public extension DependencyValues {
    var settingClient: SettingClient {
        get { self[SettingClient.self] }
        set { self[SettingClient.self] = newValue }
    }
}

