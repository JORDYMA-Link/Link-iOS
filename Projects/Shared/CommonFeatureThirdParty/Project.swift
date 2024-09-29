//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/29/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: ModulePath.Shared.CommonFeatureThirdParty.rawValue,
    targets: [
        .shared(implements: .CommonFeatureThirdParty, factory: .init(
            dependencies: [
                .external(externalDependency: .composableArchitecture),
                .external(externalDependency: .kingFisher),
                .external(externalDependency: .lottie)
            ]
        ))
    ]
)
