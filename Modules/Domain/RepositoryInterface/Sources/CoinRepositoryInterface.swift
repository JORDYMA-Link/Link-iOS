//
//  CoinRepositoryInterface.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/22/24.
//

import Foundation

import Entity

public protocol RepositoryInterface: AnyObject {
    func fetchData() async throws -> Coin
}
