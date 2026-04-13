//
//  NoticeClient.swift
//  Models
//
//  Created by 문정호 on 8/26/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import BKModel

import Dependencies
import Moya

public struct NoticeClient {
  public var getNotice: @Sendable (_ page: Int, _ size: Int) async throws -> [NoticeModel]
  
  public var getWebViewInfo: @Sendable () async throws -> WebViewInfo
}

extension NoticeClient: DependencyKey {
  public static var liveValue: NoticeClient {
    let noticeClient = Provider<NoticeEndpoint>()
    
    return Self(
      getNotice: { (page, size) in
        let responseDTO: NoticeListResponse = try await noticeClient.request(.getNotice(page: page, size: size), modelType: NoticeListResponse.self)
        return responseDTO.toDomain()
      },
      getWebViewInfo: {
        let responseDTO: WebViewInfoResponse = try await noticeClient.request(.getWebViewInfo, modelType: WebViewInfoResponse.self)
        return responseDTO.toDomain()
      }
    )
  }
}

public extension DependencyValues {
    var noticeClient: NoticeClient {
        get { self[NoticeClient.self] }
        set { self[NoticeClient.self] = newValue }
    }
}
