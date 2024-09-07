//
//  LinkProcessingStatus.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct LinkProcessingStatus: Equatable {
  public let feedId: Int
  public let title: String
  public let status: ProcessingStatusType
  
  public init(
    feedId: Int,
    title: String,
    status: ProcessingStatusType
  ) {
    self.feedId = feedId
    self.title = title
    self.status = status
  }
}

public enum ProcessingStatusType: String, CaseIterable {
  case completed = "COMPLETED"
  case requested = "REQUESTED"
  case deny = "DENY"
  
  public init(fromRawValue: String) {
    self = ProcessingStatusType(rawValue: fromRawValue) ?? .deny
  }
  
  public var title: String {
    switch self {
    case .completed:
      return "요약완료"
    case .requested:
      return "요약 중"
    case .deny:
      return "요약불가"
    }
  }
}

public extension LinkProcessingStatus {
  static func mock() -> [LinkProcessingStatus] {
    return  [
      LinkProcessingStatus(feedId: 0, title: "블링크가 요약한 링크 제목 정보가 클라이언트 상에 존재하기 때문에 그대로 띄운다 최대 2줄까지 보여집니다 길면 이렇게 됩니다", status: .completed),
      LinkProcessingStatus(feedId: 1, title: "블링크가 요약한 링크 제목 정보가 클라이언트 상에 존재하기 때문에 그대로 띄운다 최대 2줄까지 보여집니다 길면 이렇게 됩니다", status: .deny),
      LinkProcessingStatus(feedId: 2, title: "React Native와 웹이 공존하는 또 하나의 방법", status: .requested),
      LinkProcessingStatus(feedId: 3, title: "블링크가 요약한 링크 제목 정보가 클라이언트 상에 존재하기 때문에 그대로 띄운다 최대 2줄까지 보여집니다 길면 이렇게 됩니다", status: .completed),
      LinkProcessingStatus(feedId: 4, title: "React Native와 웹이 공존하는 또 하나의 방법", status: .deny),
      LinkProcessingStatus(feedId: 5, title: "블링크가 요약한 링크 제목 정보가 클라이언트 상에 존재하기 때문에 그대로 띄운다 최대 2줄까지 보여집니다 길면 이렇게 됩니다", status: .requested)
      ]
  }
}
