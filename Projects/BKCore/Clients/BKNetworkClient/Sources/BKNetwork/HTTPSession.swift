//
//  HTTPSession.swift
//  Services
//
//  Created by kyuchul on 7/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Moya

final class HTTPSession {
    static let shared = HTTPSession()

    private init() {}
    
    lazy var session: Session = {
        return Session(configuration: createConfiguration())
    }()
  
    lazy var sessionWithInterceptor: Session = {
        return Session(configuration: createConfiguration(), interceptor: TokenInterceptor.shared)
    }()

    private func createConfiguration() -> URLSessionConfiguration {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        return configuration
    }
}
