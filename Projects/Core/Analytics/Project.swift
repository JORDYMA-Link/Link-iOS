//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 11/1/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Core.Analytics.rawValue,
    targets: [
        .core(implements: .Analytics, factory: .init(
            dependencies: [
                .shared(implements: .ThirdParty)
            ]
        ))
    ]
)
