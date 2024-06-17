////
////  HomeDIContainer.swift
////  Features
////
////  Created by Kooky macBook Air on 2/23/24.
////  Copyright © 2024 kyuchul. All rights reserved.
////
//
//import UIKit
//
//import CommonFeature
//
//import Entity
//import UseCase
//import RepositoryInterface
//
//import Data
//import Core
//
//public final class HomeDIContainer: BaseDIContainer {
//
//    public init() {}
//
//    public typealias ViewModel = HomeViewModel
//    public typealias Repository = RepositoryInterface
//    public typealias UseCase = CoinUseCase
//
//    @MainActor public func makeViewModel() -> HomeViewModel {
//        return HomeViewModel(useCase: makeUseCase())
//    }
//
//    public func makeUseCase() -> UseCase {
//        return CoinUseCaselmlp(RepositoryInterface: makeRepository())
//    }
//
//    public func makeRepository() -> Repository {
//        return CoinRepository()
//    }
//}
