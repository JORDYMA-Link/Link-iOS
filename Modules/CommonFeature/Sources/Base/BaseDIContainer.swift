//
//  BaseDIContainer.swift
//  CommonFeature
//
//  Created by Kooky macBook Air on 2/23/24.
//  Copyright © 2024 kyuchul. All rights reserved.
//

import Foundation

public protocol BaseDIContainer {
    associatedtype ViewContrller
    associatedtype ViewModel
    associatedtype UseCase
    associatedtype Repository
    
    func makeViewController() -> ViewContrller
    func makeViewModel() -> ViewModel
    func makeUseCase() -> UseCase
    func makeRepository() -> Repository
}
