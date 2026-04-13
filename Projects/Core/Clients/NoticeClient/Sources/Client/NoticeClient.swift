//
//  NoticeClient.swift
//  NoticeClient
//
//  Created by 문정호 on 8/26/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKModel

import Dependencies

public struct NoticeClient {
  public var getNotice: @Sendable (_ page: Int, _ size: Int) async throws -> [NoticeModel]
  public var getWebViewInfo: @Sendable () async throws -> WebViewInfo
}

public extension DependencyValues {
  var noticeClient: NoticeClient {
    get { self[NoticeClient.self] }
    set { self[NoticeClient.self] = newValue }
  }
}
