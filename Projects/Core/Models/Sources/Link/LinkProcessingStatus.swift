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
  /// 요약 완료
  case completed = "COMPLETED"
  /// 요약 요청
  case requested = "REQUESTED"
  /// 요약 중
  case processing = "PROCESSING"
  /// 요약 불가
  case failed = "FAILED"
  
  public init(fromRawValue: String) {
    self = ProcessingStatusType(rawValue: fromRawValue) ?? .failed
  }
  
  public var title: String {
    switch self {
    case .completed:
      return "요약완료"
    case .requested, .processing:
      return "요약 중"
    case .failed:
      return "요약불가"
    }
  }
}
