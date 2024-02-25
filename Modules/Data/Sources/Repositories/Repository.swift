//
//  Repository.swift
//  Core
//
//  Created by Kooky macBook Air on 2/21/24.
//  Copyright © 2024 kyuchul. All rights reserved.
//

import Foundation

import RepositoryInterface
import Entity

import Moya

final public class CoinRepository: RepositoryInterface {
    private let service = NetworkManager<BithumbAPI>()
    
    public init() { }
    
    public func fetchData() async throws -> Coin {
        let response = try await service.request(.getData(orderCurrency: "BTC", paymentCurrency: "KRW"))
        
        let data = try parse(response)
        
        return data
    }
    
    private func parse(_ response: Response) throws -> Coin {
        return try response.map(CoinResponse.self)
            .toDomain()
    }
}
