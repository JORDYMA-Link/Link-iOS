//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 6/14/24.
//

import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
    name: ModulePath.Core.Models.rawValue,
    targets: [
        .core(implements: .Models, factory: .init(
            dependencies: [
                .shared
            ]
        ))
    ]
)

