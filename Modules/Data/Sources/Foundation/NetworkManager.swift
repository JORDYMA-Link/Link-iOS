//
//  NetworkManager.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/12/24.
//

import Foundation

import Moya

final class NetworkManager<T: TargetType> {
    private let provider = MoyaProvider<T>()
        
    func request(_ target: T) async throws -> Response {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

enum BithumbAPI {
    case getData(orderCurrency: String, paymentCurrency: String)
}

extension BithumbAPI: BaseTargetType {
    var baseURL: URL {
        return URL(string: "https://api.bithumb.com/public")!
    }
        
    var path: String {
        switch self {
        case .getData(let orderCurrency, let paymentCurrency):
            return "/ticker" + "?order_currency=\(orderCurrency)&payment_currency=\(paymentCurrency)"
        }
    }
    
    // http 요청 메소드
    var method: Moya.Method {
        switch self {
        case .getData:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getData:
            return .requestPlain
        }
    }
    
    // http 헤더
    var headers: [String : String]? {
        return [
            "content-type": "application/json"
        ]
    }
}

protocol BaseTargetType:TargetType { }

extension BaseTargetType {
    
    var baseURL: URL {
        return URL(string: "https://api.bithumb.com/public")!
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return [
            "content-type": "application/json"
        ]
    }
}

