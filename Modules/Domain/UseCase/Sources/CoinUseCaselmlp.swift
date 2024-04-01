//
//  a.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/8/24.
//

import Foundation

import RepositoryInterface
import Entity

import Moya

public protocol CoinUseCase: AnyObject {
    func execute() async throws -> Coin
}

final public class CoinUseCaselmlp: CoinUseCase {
    
    private let repositoryInterface: RepositoryInterface
    
    public init(RepositoryInterface: RepositoryInterface) {
        self.repositoryInterface = RepositoryInterface
    }
    
    public func execute() async throws -> Coin {
        do {
            let coin = try await repositoryInterface.fetchData()
            return coin
        } catch {
            throw error
        }
    }
}
