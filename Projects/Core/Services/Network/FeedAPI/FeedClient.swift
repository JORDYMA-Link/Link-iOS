//
//  FeedClient.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import Dependencies
import Moya

public struct FeedClient {
  /// 피드 상세 메모 수정
  public var postFeedMemo: @Sendable (_ feedId: Int, _ memo: String) async throws -> Feed
  /// 피드 삭제
  public var deleteFeed: @Sendable (_ feedId: Int) async throws -> Void
  /// 피드 북마크 여부 변경
  public var patchBookmark: @Sendable (_ feedId: Int, _ setMarked: Bool) async throws -> FeedBookmark
  /// 피드 상세 조회
  public var getFeed: @Sendable (_ feedId: Int) async throws -> Feed
}

extension FeedClient: DependencyKey {
  public static var liveValue: FeedClient {
    let feedProvider = Provider<FeedEndpoint>()
    
    return Self(
      postFeedMemo: { feedId, memo in
        let responseDTO: FeedResponse = try await feedProvider.request(.postFeedMemo(feedId: feedId, memo: memo), modelType: FeedResponse.self)
        
        return responseDTO.toDomain()
      },
      deleteFeed: { feedId in
        return try await feedProvider.requestPlain(.deleteFeed(feedId: feedId))
      },
      patchBookmark: { feedId, setMarked in
        let responseDTO: FeedBookmarkResponse = try await feedProvider.request(.patchBookmark(feedId: feedId, setMarked: setMarked), modelType: FeedBookmarkResponse.self)
        
        return responseDTO.toDomain()
      },
      getFeed: { feedId in
        let responseDTO: FeedResponse = try await feedProvider.request(.getFeed(feedId: feedId), modelType: FeedResponse.self)
        
        return responseDTO.toDomain()
      }
    )
  }
}

public extension DependencyValues {
  var feedClient: FeedClient {
    get { self[FeedClient.self] }
    set { self[FeedClient.self] = newValue }
  }
}
