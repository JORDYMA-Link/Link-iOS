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
  /// 피드 상세 조회
  public var getFeed: @Sendable (_ feedId: Int) async throws -> Feed
}

extension FeedClient: DependencyKey {
  public static var liveValue: FeedClient {
    let feedProvider = Provider<FeedEndpoint>()
    
    return Self(
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
