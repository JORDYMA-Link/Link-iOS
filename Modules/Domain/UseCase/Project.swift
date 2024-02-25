//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/25/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let name = "UseCase"

let project = Project.makeModule(
    name: name,
    product: .staticFramework,
    targets: [],
    dependencies: [
        .Domain.entity,
        .Domain.repositoryInterface
    ]
)
