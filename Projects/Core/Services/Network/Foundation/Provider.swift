//
//  Provider.swift
//  Services
//
//  Created by kyuchul on 7/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import OSLog
import Combine

import Moya

protocol Providable<APIType> {
  associatedtype APIType: BaseTargetType
  
  /// async throws request
  func request<D: Decodable> (_ target: APIType, modelType: D.Type) async throws -> D
  /// async throws null request
  func requestPlain(_ api: APIType) async throws
  /// combine request
  func requestPublisher<D: Decodable> (_ api: APIType, modelType: D.Type) -> AnyPublisher<D, Error>
}

struct Provider<APIType: BaseTargetType>: Providable {
  private let moyaProvider: MoyaProvider<APIType>
  private let isRetry: Bool
  
  init(isRetry: Bool = true) {
    self.isRetry = isRetry
    
    let session = isRetry ? HTTPSession.shared.sessionWithInterceptor : HTTPSession.shared.session
    let plugIn = NetworkLoggerPlugin()
    moyaProvider = .init(session: session, plugins: [plugIn])
  }
}

extension Provider {
  func request<D: Decodable> (_ api: APIType, modelType: D.Type) async throws -> D {
    return try await withCheckedThrowingContinuation { continuation in
      moyaProvider.request(api) { result in
        switch result {
        case let .success(response):
          guard 200..<300 ~= response.statusCode else {
            let errorResponse = try? JSONDecoder.default.decode(ErrorResponse.self, from: response.data)
            os_log("errorResponse: \(errorResponse)")
            continuation.resume(throwing: errorResponse ?? MoyaError.statusCode(response))
            return
          }
          
          guard let successResponse = try? JSONDecoder.default.decode(D.self, from: response.data) else {
            continuation.resume(throwing: MoyaError.jsonMapping(response))
            return
          }
          
          continuation.resume(returning: successResponse)
          
        case let .failure(error):
          continuation.resume(throwing: error)
          return
        }
      }
    }
  }
  
  func requestPlain(_ api: APIType) async throws {
    return try await withCheckedThrowingContinuation { continuation in
      moyaProvider.request(api) { result in
        switch result {
        case let .success(response):
          guard 200..<300 ~= response.statusCode else {
            let errorResponse = try? JSONDecoder.default.decode(ErrorResponse.self, from: response.data)
            os_log("errorResponse: \(errorResponse)")
            continuation.resume(throwing: errorResponse ?? MoyaError.statusCode(response))
            return
          }
          
          continuation.resume(returning: ())
          
        case let .failure(error):
          continuation.resume(throwing: error)
          return
        }
      }
    }
  }
  
  func requestPublisher<D: Decodable> (_ api: APIType, modelType: D.Type) -> AnyPublisher<D, Error> {
    Future<D, Error> { promise in
      moyaProvider.request(api) { result in
        switch result {
        case let .success(response):
          guard 200..<300 ~= response.statusCode else {
            let errorResponse = try? JSONDecoder.default.decode(ErrorResponse.self, from: response.data)
            os_log("errorResponse: \(errorResponse)")
            promise(.failure(errorResponse ?? MoyaError.statusCode(response)))
            return
          }
          
          guard let successResponse = try? JSONDecoder.default.decode(D.self, from: response.data) else {
            promise(.failure(MoyaError.jsonMapping(response)))
            return
          }
          
          promise(.success(successResponse))
          
        case let .failure(error):
          promise(.failure(error))
        }
      }
    }.eraseToAnyPublisher()
  }
}
