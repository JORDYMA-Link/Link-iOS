//
//  TokenInterceptor.swift
//  BKNetwork
//
//  Created by kyuchul on 6/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import BKCommon
import BKModel

import Alamofire
import Dependencies

public final class TokenInterceptor: RequestInterceptor {
  @Dependency(\.keychainClient) var keychainClient

  static let shared = TokenInterceptor()
  private init() {}

  public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
    var request = urlRequest
    request.headers.add(.authorization(bearerToken: keychainClient.read(.accessToken)))

    completion(.success(request))
  }

  public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    guard let response = request.response, response.statusCode == 401 else {
      completion(.doNotRetryWithError(error))
      return
    }

    _Concurrency.Task {
      do {
        let tokenInfo = try await regenerateToken(refreshToken: keychainClient.read(.refreshToken))

        try await keychainClient.save(.accessToken, tokenInfo.accessToken)
        try await keychainClient.save(.refreshToken, tokenInfo.refreshToken)

        completion(.retryWithDelay(1))
      } catch {
        try await keychainClient.delete(.accessToken)
        try await keychainClient.delete(.refreshToken)

        completion(.doNotRetryWithError(error))

        DispatchQueue.main.async {
          NotificationCenter.default.post(name: .tokenExpired, object: nil)
        }
      }
    }
  }
}

// MARK: - Token Regeneration (AuthClient 순환 의존 방지를 위해 URLSession 직접 사용)

private extension TokenInterceptor {
  func regenerateToken(refreshToken: String) async throws -> TokenInfo {
    guard
      let urlString = Bundle.main.infoDictionary?["BASE_URL"] as? String,
      let url = URL(string: urlString + "/auth/regenerate-token")
    else {
      throw URLError(.badURL)
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-type")
    request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")

    let (data, response) = try await URLSession.shared.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse,
          200..<300 ~= httpResponse.statusCode else {
      throw URLError(.badServerResponse)
    }

    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

    guard let accessToken = json?["accessToken"] as? String,
          let newRefreshToken = json?["refreshToken"] as? String else {
      throw URLError(.cannotParseResponse)
    }

    return TokenInfo(accessToken: accessToken, refreshToken: newRefreshToken)
  }
}
