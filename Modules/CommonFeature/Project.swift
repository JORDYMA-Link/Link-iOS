//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/21/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let name = "CommonFeature"

let project = Project.makeModule(
    name: name,
    product: .staticFramework,
    targets: [],
    includeResource: true,
    resourceSynthesizers: [
        .custom(name: "Lottie", parser: .json, extensions: ["lottie"]),
        .fonts(),
        .assets()
    ],
    dependencies: [
        .Domain.useCase,
        .core
    ]
)
