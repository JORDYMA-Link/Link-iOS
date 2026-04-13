//
//  KakaoChannelClient+Live.swift
//  Services
//
//  Created by kyuchul on 12/24/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import KakaoSDKTalk

import Dependencies

extension KakaoChannelClient: DependencyKey {
  public static var liveValue: KakaoChannelClient = live()
  private static func live() -> KakaoChannelClient {

    return KakaoChannelClient {
      var activeContinuation: CheckedContinuation<Void, Error>?

      return try await withCheckedThrowingContinuation { continuation in
        activeContinuation = continuation

        TalkApi.shared.chatChannel(channelPublicId: "_zxfwdn") { error in
          if let error {
            activeContinuation?.resume(throwing: error)
            activeContinuation = nil
          } else {
            activeContinuation?.resume(returning: ())
            activeContinuation = nil
          }
        }
      }
    }
  }
}
