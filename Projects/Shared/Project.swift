//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/27/24.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Shared.name,
    targets: [
        .shared(
            factory: .init(
                product: .staticFramework,
                sources: nil,
                dependencies: [
                    .shared(implements: .BKModel),
                    .shared(implements: .CommonFeature)
                ]
            )
        )
    ]
)

