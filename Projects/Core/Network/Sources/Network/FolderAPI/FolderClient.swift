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

@available(*, deprecated, message: "Domain 모듈로 이관하여 사용 예정")
public struct FolderClient {
  /// 보관함 폴더 리스트 조회
  public var getFolders: @Sendable () async throws -> [Folder]
  public var getFolderFeeds: @Sendable (_ folderId: Int, _ cursor: Int) async throws -> [FeedCard]
  /// 폴더 생성
  public var postFolder: @Sendable (_ name: String) async throws -> Folder
  /// 온보딩 주제 선택
  public var postOnboardingFolder: @Sendable (_ topics: [String]) async throws -> OnboardingFolder
  /// 폴더 삭제
  public var deleteFolder: @Sendable (_ folderId: Int) async throws -> Void
  /// 폴더 수정
  public var patchFolder: @Sendable (_ folderId: Int, _ name: String) async throws -> Folder
  /// 피드에 폴더 지정
  public var patchFeedFolder: @Sendable (_ folderId: Int, _ name: String) async throws -> Folder
}

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

public extension DependencyValues {
  var folderClient: FolderClient {
    get { self[FolderClient.self] }
    set { self[FolderClient.self] = newValue }
  }
}
