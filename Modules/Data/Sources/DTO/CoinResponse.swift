//
//  CoinResponse.swift
//  Data
//
//  Created by Kooky macBook Air on 2/21/24.
//  Copyright © 2024 kyuchul. All rights reserved.
//

import Foundation

import Entity

struct CoinResponse: Decodable  {
    let data: ResponseData
}

struct ResponseData: Decodable {
    let opening_price: String
    let closing_price: String
    let min_price: String
    let max_price: String
    let acc_trade_value: String
    let prev_closing_price: String
    let units_traded_24H: String
    let acc_trade_value_24H: String
    let fluctate_24H: String
    let fluctate_rate_24H: String
    let date: String
}

extension CoinResponse {
    func toDomain() -> Coin {
        return .init(data: data.toDomain())
    }
}

extension ResponseData {
    func toDomain() -> ResponseCoin {
        return .init(opening_price: opening_price, closing_price: closing_price, min_price: min_price, max_price: max_price, acc_trade_value: acc_trade_value, prev_closing_price: prev_closing_price, units_traded_24H: units_traded_24H, acc_trade_value_24H: acc_trade_value_24H, fluctate_24H: fluctate_24H, fluctate_rate_24H: fluctate_rate_24H, date: date)
    }
}
