//
//  Provider.swift
//  Services
//
//  Created by kyuchul on 6/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import Combine
import OSLog

import Moya

extension MoyaProvider {
  func request<D: Decodable> (_ target: Target, modelType: D.Type) async throws -> D {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { result in
        switch result {
        case let .success(response):
          guard 200..<300 ~= response.statusCode else {
            let errorResponse = try? JSONDecoder.default.decode(ErrorResponse.self, from: response.data)
            os_log("errorResponse: \(errorResponse)")
            continuation.resume(throwing: errorResponse ?? NetworkError.errorResponseCanNotParse)
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
  
  func requestPlain<D: Decodable> (_ target: Target, modelType: D.Type) async throws {
    return try await withCheckedThrowingContinuation { continuation in
      self.request(target) { result in
        switch result {
        case let .success(response):
          guard 200..<300 ~= response.statusCode else {
            let errorResponse = try? JSONDecoder.default.decode(ErrorResponse.self, from: response.data)
            os_log("errorResponse: \(errorResponse)")
            continuation.resume(throwing: errorResponse ?? NetworkError.errorResponseCanNotParse)
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
  
  func requestPublisher<D: Decodable> (_ target: Target, modelType: D.Type) -> AnyPublisher<D, Error> {
    Future<D, Error> { promise in
      self.request(target) { result in
        switch result {
        case let .success(response):
          guard 200..<300 ~= response.statusCode else {
            let errorResponse = try? JSONDecoder.default.decode(ErrorResponse.self, from: response.data)
            os_log("errorResponse: \(errorResponse)")
            promise(.failure(errorResponse ?? NetworkError.errorResponseCanNotParse))
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

extension JSONDecoder {
  static var `default`: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }
}

enum NetworkError: Error {
  case errorResponseCanNotParse
}
