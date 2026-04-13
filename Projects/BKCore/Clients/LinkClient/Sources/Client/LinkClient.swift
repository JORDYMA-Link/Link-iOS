//
//  LinkClient.swift
//  LinkClient
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKModel

import Dependencies

public struct LinkClient {
  /// 링크 요약
  public var postLinkSummary: @Sendable (_ link: String) async throws -> Int
  /// 링크 썸네일 이미지 업로드
  public var postLinkImage: @Sendable (_ feedId: Int, _ thumbnailImage: Data) async throws -> Void
  /// 링크 저장(수정)
  public var patchLink: @Sendable (
    _ feedId: Int,
    _ folderName: String,
    _ title: String,
    _ summary: String,
    _ keywords: [String],
    _ memo: String
  ) async throws -> Int
  /// 링크 요약 결과 조회
  public var getLinkSummary: @Sendable (_ feedId: Int) async throws -> Feed
  /// 요약 중인 링크 조회
  public var getLinkProcessing: @Sendable () async throws -> LinkProcessing
  /// 요약 불가 링크 삭제
  public var deleteLinkDenySummary: @Sendable (_ feedId: Int) async throws -> Void
}

public extension DependencyValues {
  var linkClient: LinkClient {
    get { self[LinkClient.self] }
    set { self[LinkClient.self] = newValue }
  }
}
