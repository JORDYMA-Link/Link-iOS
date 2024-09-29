//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 6/14/24.
//

import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
    name: ModulePath.Core.Services.rawValue,
    targets: [
        .core(implements: .Services, factory: .init(
            dependencies: [
                .shared(implements: .ThirdParty),
                .core(implements: .Models),
                .shared
            ]
        ))
    ]
)

