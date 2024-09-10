//
//  LinkClient.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Models

import Dependencies
import Moya

public struct LinkClient {
  /// 링크 요약
  public var postLinkSummary: @Sendable (_ link: String, _ content: String) async throws -> Int
  /// 링크 썸네일 이미지 업로드
  public var postLinkImage: @Sendable (_ feedId: Int, _ thumbnailImage: Data) async throws -> String
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

extension LinkClient: DependencyKey {
  public static var liveValue: LinkClient {
    let linkProvider = Provider<LinkEndpoint>()
    
    return Self(
      postLinkSummary: { link, content in
        let responseDTO: FeedIDResponse = try await linkProvider.request(.postLinkSummary(link: link, content: content), modelType: FeedIDResponse.self)
        return responseDTO.feedId
      },
      postLinkImage: { feedId, thumbnailImage in
        return try await linkProvider.request(.postLinkImage(feedId: feedId, thumbnailImage: thumbnailImage), modelType: String.self)
      },
      patchLink: { feedId, folderName, title, summary, keywords, memo in
        let responseDTO: FeedIDResponse = try await linkProvider.request(.patchLink(feedId: feedId, folderName: folderName, title: title, summary: summary, keywords: keywords, memo: memo), modelType: FeedIDResponse.self)
        
        return responseDTO.feedId
      }, getLinkSummary: { feedId in
        let responseDTO: LinkSummaryResponse = try await linkProvider.request(.getLinkSummary(feedId: feedId), modelType: LinkSummaryResponse.self)
        
        return responseDTO.toDomain()
      },
      getLinkProcessing: {
        let responseDTO: LinkProcessingResponse = try await linkProvider.request(.getLinkProcessing, modelType: LinkProcessingResponse.self)
        return responseDTO.toDomain()
      },
      deleteLinkDenySummary: { feedId in
        return try await linkProvider.requestPlain(.deleteLinkDenySummary(feedId: feedId))
      }
    )
  }
}

public extension DependencyValues {
  var linkClient: LinkClient {
    get { self[LinkClient.self] }
    set { self[LinkClient.self] = newValue }
  }
}
