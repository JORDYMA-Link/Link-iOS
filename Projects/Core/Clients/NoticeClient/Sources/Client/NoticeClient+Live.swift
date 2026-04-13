//
//  NoticeClient+Live.swift
//  NoticeClient
//
//  Created by 문정호 on 8/26/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKNetwork

import Dependencies

extension NoticeClient: DependencyKey {
  public static var liveValue: NoticeClient {
    let noticeProvider = Provider<NoticeEndpoint>()

    return Self(
      getNotice: { (page, size) in
        let responseDTO: NoticeListResponse = try await noticeProvider.request(.getNotice(page: page, size: size), modelType: NoticeListResponse.self)
        return responseDTO.toDomain()
      },
      getWebViewInfo: {
        let responseDTO: WebViewInfoResponse = try await noticeProvider.request(.getWebViewInfo, modelType: WebViewInfoResponse.self)
        return responseDTO.toDomain()
      }
    )
  }
}
