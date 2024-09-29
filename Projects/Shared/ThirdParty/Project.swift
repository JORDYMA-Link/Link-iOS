//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/27/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Shared.ThirdParty.rawValue,
    targets: [
        .shared(
            implements: .ThirdParty,
            factory: .init(
                dependencies: [
                    .external(externalDependency: .composableArchitecture),
                    .external(externalDependency: .kakaoSDK),
                    .external(externalDependency: .firebaseAnalytics),
                    .external(externalDependency: .firebaseMessaging),
                    .external(externalDependency: .moya),
                    .external(externalDependency: .introspect),
                    .external(externalDependency: .FSCalendar)
                ]
            )
        )
    ]
)
