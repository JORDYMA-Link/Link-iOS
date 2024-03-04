//
//  Coin.swift
//  Domain
//
//  Created by Kooky macBook Air on 2/21/24.
//  Copyright © 2024 kyuchul. All rights reserved.
//

import Foundation

public struct Coin: Codable  {
    public let data: ResponseCoin
        
    public init(data: ResponseCoin) {
        self.data = data
    }
}

public struct ResponseCoin: Codable {
    public let opening_price: String
    public let closing_price: String
    public let min_price: String
    public let max_price: String
    public let acc_trade_value: String
    public let prev_closing_price: String
    public let units_traded_24H: String
    public let acc_trade_value_24H: String
    public let fluctate_24H: String
    public let fluctate_rate_24H: String
    public let date: String
    
    public init(opening_price: String, closing_price: String, min_price: String, max_price: String, acc_trade_value: String, prev_closing_price: String, units_traded_24H: String, acc_trade_value_24H: String, fluctate_24H: String, fluctate_rate_24H: String, date: String) {
        self.opening_price = opening_price
        self.closing_price = closing_price
        self.min_price = min_price
        self.max_price = max_price
        self.acc_trade_value = acc_trade_value
        self.prev_closing_price = prev_closing_price
        self.units_traded_24H = units_traded_24H
        self.acc_trade_value_24H = acc_trade_value_24H
        self.fluctate_24H = fluctate_24H
        self.fluctate_rate_24H = fluctate_rate_24H
        self.date = date
    }
}
