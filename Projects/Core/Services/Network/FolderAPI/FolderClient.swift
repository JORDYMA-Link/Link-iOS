//
//  FolderClient.swift
//  Services
//
//  Created by kyuchul on 8/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import Dependencies
import Moya

public struct FolderClient {
  public var getFolders: @Sendable () async throws -> [Folder]
  public var postFolder: @Sendable (_ name: String) async throws -> Folder
  public var postOnboardingFolder: @Sendable (_ topics: [String]) async throws -> OnboardingFolder
  public var deleteFolder: @Sendable (_ folderId: String) async throws -> Void
  public var fetchFolder: @Sendable (_ folderId: String, _ name: String) async throws -> Folder
}

extension FolderClient: DependencyKey {
  public static var liveValue: FolderClient {
    let folderProvider = Provider<FolderEndpoint>()
    
    return Self(
      getFolders: {
        let responseDTO: FolderListResponse = try await folderProvider.request(.getFolders, modelType: FolderListResponse.self)
        return responseDTO.toDomain()
      },
      postFolder: { name in
        let responseDTO: FolderResponse = try await folderProvider.request(.postFolder(name: name), modelType: FolderResponse.self)
        return responseDTO.toDomain()
      },
      postOnboardingFolder: { topics in
        let responseDTO: OnboardingFolderResponse = try await folderProvider.request(.postOnboardingFolder(topics: topics), modelType: OnboardingFolderResponse.self)
        return responseDTO.toDomain()
      },
      deleteFolder: { folderId in
        return try await folderProvider.requestPlain(.deleteFolder(folderId: folderId))
      },
      fetchFolder: { folderId, name in
        let responseDTO: FolderResponse = try await folderProvider.request(.fetchFolder(folderId: folderId, name: name), modelType: FolderResponse.self)
        return responseDTO.toDomain()
      }
    )
  }
}

public extension DependencyValues {
    var folderClient: FolderClient {
        get { self[FolderClient.self] }
        set { self[FolderClient.self] = newValue }
    }
}
