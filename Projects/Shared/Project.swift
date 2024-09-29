//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/27/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: ModulePath.Shared.name,
    targets: [
        .shared(
            factory: .init(
                product: .staticFramework,
                sources: nil,
                dependencies: [
                    .shared(implements: .Common),
                    .shared(implements: .CommonFeature)
                ]
            )
        )
    ]
)

