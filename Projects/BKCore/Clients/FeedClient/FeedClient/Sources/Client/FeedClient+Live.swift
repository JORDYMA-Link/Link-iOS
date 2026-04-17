//
//  FeedClient+Live.swift
//  FeedClient
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKNetworkClient
import FeedClientInterface

import Dependencies

extension FeedClient: DependencyKey {
  public static var liveValue: FeedClient {
    let feedProvider = Provider<FeedEndpoint>()

    return Self(
      postFeedMemo: { feedId, memo in
        let responseDTO: FeedResponse = try await feedProvider.request(.postFeedMemo(feedId: feedId, memo: memo), modelType: FeedResponse.self)
        return responseDTO.toDomain()
      },
      postFeedByType: { type, page in
        let responseDTO: FeedCardListResponse = try await feedProvider.request(.postFeedByType(type: type, page: page), modelType: FeedCardListResponse.self)
        return responseDTO.feedList.map { $0.toDomain() }
      },
      deleteFeed: { feedId in
        return try await feedProvider.requestPlain(.deleteFeed(feedId: feedId))
      },
      patchBookmark: { feedId, setMarked in
        let responseDTO: FeedBookmarkResponse = try await feedProvider.request(.patchBookmark(feedId: feedId, setMarked: setMarked), modelType: FeedBookmarkResponse.self)
        return responseDTO.toDomain()
      },
      getFeedSearch: { query, page in
        let responseDTO: SearchFeedResponse = try await feedProvider.request(.getFeedSearch(query: query, page: page), modelType: SearchFeedResponse.self)
        return responseDTO.toDomain()
      },
      getFeed: { feedId in
        let responseDTO: FeedResponse = try await feedProvider.request(.getFeed(feedId: feedId), modelType: FeedResponse.self)
        return responseDTO.toDomain()
      },
      getFeedCalendarSearch: { date in
        let responseDTO: FeedCalendarSearchResponse = try await feedProvider.request(.getFeedSearchByDate(date: date), modelType: FeedCalendarSearchResponse.self)
        return responseDTO.toDomain()
      },
      getFeedChallenge: {
        let responseDTO: FeedChallengeResponse = try await feedProvider.request(.getFeedChallenge, modelType: FeedChallengeResponse.self)
        return responseDTO.toDomain()
      }
    )
  }
}
