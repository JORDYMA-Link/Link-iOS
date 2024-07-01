//
//  CommonMoyaProvider.swift
//  Services
//
//  Created by kyuchul on 6/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

import Moya

final class CommonMoyaProvider<T: TargetType>: MoyaProvider<T> {
  
  private var isInterceptor: Bool
  
  init(isInterceptor: Bool = true) {
    self.isInterceptor = isInterceptor
    
    let configuration = URLSessionConfiguration.af.default
    configuration.timeoutIntervalForRequest = 10
    configuration.timeoutIntervalForResource = 10
    
    let session = isInterceptor ? Session(configuration: configuration, interceptor: TokenInterceptor.shard) : Session(configuration: configuration)
    let plugIn = NetworkLoggerPlugin()
    
    super.init(session: session, plugins: [plugIn])
  }
}
