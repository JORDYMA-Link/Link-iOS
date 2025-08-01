//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Claude on 8/1/25.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Core.Network.rawValue,
    targets: [
        .core(implements: .Network, factory: .init(
            dependencies: [
                .external(externalDependency: .moya),
                .core(implements: .Models)
            ]
        ))
    ]
)