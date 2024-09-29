//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 6/14/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: ModulePath.Core.name,
    targets: [
        .core(factory: .init(
            product: .staticFramework,
            sources: nil,
            dependencies: [
                .core(implements: .Models),
                .core(implements: .Services),
                .shared
            ]
        ))
    ]
)
