//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 6/14/24.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Core.name,
    targets: [
        .core(factory: .init(
            product: .staticFramework,
            sources: nil,
            dependencies: [
                .core(implements: .Analytics),
                .core(implements: .BKNetwork),
                .core(implements: .Services)
            ]
        ))
    ]
)

