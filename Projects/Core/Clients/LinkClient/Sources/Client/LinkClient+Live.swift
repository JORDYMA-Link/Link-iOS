//
//  LinkClient+Live.swift
//  LinkClient
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import FeedClientInterface
import BKNetwork

import Dependencies

extension LinkClient: DependencyKey {
  public static var liveValue: LinkClient {
    let linkProvider = Provider<LinkEndpoint>()

    return Self(
      postLinkSummary: { link in
        let responseDTO: FeedIDResponse = try await linkProvider.request(.postLinkSummary(link: link), modelType: FeedIDResponse.self)
        return responseDTO.feedId
      },
      postLinkImage: { feedId, thumbnailImage in
        return try await linkProvider.requestPlain(.postLinkImage(feedId: feedId, thumbnailImage: thumbnailImage))
      },
      patchLink: { feedId, folderName, title, summary, keywords, memo in
        let responseDTO: FeedIDResponse = try await linkProvider.request(.patchLink(feedId: feedId, folderName: folderName, title: title, summary: summary, keywords: keywords, memo: memo), modelType: FeedIDResponse.self)
        return responseDTO.feedId
      },
      getLinkSummary: { feedId in
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
