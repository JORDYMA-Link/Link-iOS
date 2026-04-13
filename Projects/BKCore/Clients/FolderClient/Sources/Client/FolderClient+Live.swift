//
//  FolderClient+Live.swift
//  FolderClient
//
//  Created by kyuchul on 8/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKNetworkClient

import Dependencies

extension FolderClient: DependencyKey {
  public static var liveValue: FolderClient {
    let folderProvider = Provider<FolderEndpoint>()

    return Self(
      getFolders: {
        let responseDTO: FolderListResponse = try await folderProvider.request(.getFolders, modelType: FolderListResponse.self)
        return responseDTO.toDomain()
      },
      getFolderFeeds: { folderId, cursor in
        let responseDTO: FolderFeedListResponse = try await folderProvider.request(.getFolderFeeds(folderId: folderId, cursor: cursor), modelType: FolderFeedListResponse.self)
        return responseDTO.feedList.map { $0.toDomain() }
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
      patchFolder: { folderId, name in
        let responseDTO: FolderResponse = try await folderProvider.request(.patchFolder(folderId: folderId, name: name), modelType: FolderResponse.self)
        return responseDTO.toDomain()
      },
      patchFeedFolder: { feedId, name in
        let responseDTO: FolderResponse = try await folderProvider.request(.patchFeedFolder(feedId: feedId, name: name), modelType: FolderResponse.self)
        return responseDTO.toDomain()
      }
    )
  }
}
