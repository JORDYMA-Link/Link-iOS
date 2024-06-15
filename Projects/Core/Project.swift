//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 6/14/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Core",
    targets: [
        .make(
            name: "CoreKit",
            product: .framework,
            bundleId: DefaultSetting.bundleId(moduleName: "coreKit"),
            sources: ["CoreKit/**"],
            dependencies: [
                .target(name: .models),
                .target(name: .services),
                .target(name: .common)
            ],
            settings: .settings(base: DefaultSetting.baseProductSetting)
        ),
        .make(
            name: "Models",
            product: .framework,
            bundleId: DefaultSetting.bundleId(moduleName: "models"),
            sources: ["Models/**"],
            dependencies: []
        ),
        .make(
            name: "Services",
            product: .framework,
            bundleId: DefaultSetting.bundleId(moduleName: "services"),
            sources: ["Services/**"],
            dependencies: [
                .external(externalDependency: .composableArchitecture),
                .external(externalDependency: .moya)
            ]
        ),
        .make(
            name: "Common",
            product: .framework,
            bundleId: DefaultSetting.bundleId(moduleName: "common"),
            sources: ["Common/**"],
            dependencies: []
        )
    ]
)

