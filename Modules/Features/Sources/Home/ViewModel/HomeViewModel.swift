//
//  HomeViewModel.swift
//  Features
//
//  Created by Kooky macBook Air on 2/22/24.
//  Copyright © 2024 kyuchul. All rights reserved.
//

import Foundation

import UseCase
import Entity

@MainActor
public final class HomeViewModel: ObservableObject {
    
    private let useCase: CoinUseCase
    
    @Published var coin: [Coin] = []
    
    public init(useCase: CoinUseCase) {
        self.useCase = useCase
    }
    
    func loadCoinData() {
        Task {
            do {
                let coin = try await useCase.execute()
                print("coin", coin)
                self.coin.append(coin)
            } catch {
                print(error)
            }
        }
    }
}
