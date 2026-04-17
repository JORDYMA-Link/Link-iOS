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
    name: ModulePath.DesignSystem.BKDesignSystemThirdParty.rawValue,
    targets: [
        .designSystem(implements: .BKDesignSystemThirdParty, factory: .init(
            dependencies: [
                .external(externalDependency: .fSPagerViewSwift),
                .external(externalDependency: .kingFisher),
                .external(externalDependency: .lottie)
            ]
        ))
    ]
)
