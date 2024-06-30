//
//  NetworkLoggerPlugin.swift
//  Services
//
//  Created by kyuchul on 6/30/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Moya

public struct NetworkLoggerPlugin: PluginType {
  public func willSend(_ request: RequestType, target: TargetType) {
    #if DEBUG
    guard let request = request.request,
          let method = request.method else { return }

    let methodRawValue = method.rawValue
    let requestDescription = request.debugDescription
    let headers = String(describing: target.headers)

    let message = """
    [Moya-Logger] - @\(methodRawValue): \(requestDescription)
    [Moya-Logger] headers: \(headers)
    \n
    """
    print(message)
    #endif
  }

  public func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
    #if DEBUG
    print("[Moya-Logger] - \(target.baseURL)\(target.path)")

    switch result {
    case .success(let response):
      guard let json = try? response.mapJSON() as? [String: Any] else { return }
      print("[Moya-Logger] Success: \(json)")
    case .failure(let error):
      print("[Moya-Logger] Fail: \(String(describing: error.errorDescription))")
    }
    #endif
  }
}
