//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/27/24.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Shared.ThirdParty.rawValue,
    targets: [
        .shared(
            implements: .ThirdParty,
            factory: .init(
                dependencies: [
                    .external(externalDependency: .firebaseMessaging),
                    .external(externalDependency: .googleMobileAds),
                    .external(externalDependency: .introspect),
                    .external(externalDependency: .fSCalendar),
                    .sdk(name: "JavaScriptCore", type: .framework)
                ]
            )
        )
    ]
)
