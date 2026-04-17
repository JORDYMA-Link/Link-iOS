//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/29/24.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.DesignSystem.BKDesignSystem.rawValue,
    targets: [
        .designSystem(implements: .BKDesignSystem, factory: .init(
            dependencies: [
                .shared,
                .designSystem(implements: .BKDesignSystemThirdParty),
                .external(externalDependency: .perception)
            ]
        )),
        .designSystem(example: .BKDesignSystem, factory: .init(
            dependencies: [
                .designSystem(implements: .BKDesignSystem)
            ]
        ))
    ],
    resourceSynthesizers: [
      .custom(name: "JSON", parser: .json, extensions: ["json"]),
      .custom(name: "Lottie", parser: .json, extensions: ["lottie"]),
      .fonts(),
      .assets()
    ]
)
