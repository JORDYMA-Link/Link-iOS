//
//  FeedChallenge.swift
//  Models
//
//  Created by kyuchul on 3/16/25.
//  Copyright © 2025 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct FeedChallenge: Equatable {
  public let isVisible: Bool
  public let challengeType: FeedChallengeType
  
  public init(
    isVisible: Bool,
    challengeType: FeedChallengeType
  ) {
    self.isVisible = isVisible
    self.challengeType = challengeType
  }
} 

public enum FeedChallengeType: Int, CaseIterable {
  case one = 1
  case two = 2
  case three = 3
  case four = 4
  case complete = 5
  case error = 0
  
  init(fromInt value: Int) {
    switch value {
    case 1:
      self = .one
    case 2:
      self = .two
    case 3:
      self = .three
    case 4:
      self = .four
    case 5...:
      self = .complete
    default:
      self = .error
    }
  }
  
  public var title: String {
    switch self {
    case .one:
      "1번째 저장 완료!"
    case .two:
      "2번째 저장 완료!"
    case .three:
      "3번째 저장 완료!"
    case .four:
      "4번째 저장 완료!"
    case .complete:
      "저장 챌린지, 완주 성공!"
    case .error:
      ""
    }
  }
  
  public var subTitle: String {
    switch self {
    case .one:
      "시작이 반이다 🏃‍♀️\n내일도 저장 잊지 마세요!"
    case .two:
      "잘하고 있어요 🔥\n3일차도 같이 달려봐요!"
    case .three:
      "절반 넘었어요 ✨\n마지막까지 파이팅!"
    case .four:
      "대박! 이제 마지막 하나만\n더 저장하면 끝 😎"
    case .complete:
      "5일간 열심히 쌓아오셨네요!\n이제 마지막 한 걸음만 남았어요"
    case .error:
      ""
    }
  }
}
