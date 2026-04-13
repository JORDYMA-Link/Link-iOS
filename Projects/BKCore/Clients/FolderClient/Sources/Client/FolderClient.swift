//
//  FolderClient.swift
//  FolderClient
//
//  Created by kyuchul on 8/8/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKModel

import Dependencies

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

public extension DependencyValues {
  var folderClient: FolderClient {
    get { self[FolderClient.self] }
    set { self[FolderClient.self] = newValue }
  }
}
