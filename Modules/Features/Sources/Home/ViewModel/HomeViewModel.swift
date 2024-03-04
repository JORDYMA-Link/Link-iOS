//
//  HomeViewModel.swift
//  Features
//
//  Created by Kooky macBook Air on 2/22/24.
//  Copyright © 2024 kyuchul. All rights reserved.
//

import Foundation

import UseCase

public final class HomeViewModel {
    
    private let useCase: CoinUseCase
    
    public init(useCase: CoinUseCase) {
        self.useCase = useCase
    }
    
    func loadCoinData() {
        Task {
            do {
                let coin = try await useCase.execute()
                print(coin)
            } catch {
                print(error)
            }
        }
    }
}
