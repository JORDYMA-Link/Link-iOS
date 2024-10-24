//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 10/18/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Domain.name,
    targets: [
        .domain(factory: .init(
            product: .staticFramework,
            sources: nil,
            dependencies: [
                .core,
                .domain(implements: .Folder)
            ]
        ))
    ]
)
