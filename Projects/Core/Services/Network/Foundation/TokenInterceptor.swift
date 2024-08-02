//
//  TokenInterceptor.swift
//  Services
//
//  Created by kyuchul on 6/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Dependencies
import Alamofire
import Moya

public final class TokenInterceptor: RequestInterceptor {
  @Dependency(\.keychainClient) var keychainClient
  @Dependency(\.authClient) var authClient
  
  static let shared = TokenInterceptor()
  private init() { }
  
  
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
        let regenerateToken = try await authClient.requestRegenerateToken(keychainClient.read(.refreshToken))
        
        try await keychainClient.save(.accessToken, regenerateToken.accessToken)
        try await keychainClient.save(.refreshToken, regenerateToken.refreshToken)
        
        completion(.retryWithDelay(1))
      } catch {
        try await keychainClient.delete(.accessToken)
        try await keychainClient.delete(.refreshToken)
        
        DispatchQueue.main.async {
          NotificationCenter.default.post(name: .tokenExpired, object: nil)
        }
        
        completion(.doNotRetryWithError(error))
      }
    }
  }
}


public extension Notification.Name {
  static let tokenExpired = Notification.Name("tokenExpired")
}
