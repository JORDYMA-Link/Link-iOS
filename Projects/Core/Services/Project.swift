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
    name: ModulePath.Core.Services.rawValue,
    targets: [
        .core(implements: .Services, factory: .init(
            dependencies: [
                .core(implements: .Models),
                .shared(implements: .ThirdParty)
            ]
        ))
    ]
)

