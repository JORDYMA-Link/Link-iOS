//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/29/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Shared.CommonFeature.rawValue,
    targets: [
        .shared(implements: .CommonFeature, factory: .init(
            dependencies: [
                .shared(implements: .CommonFeatureThirdParty)
            ]
        )),
        .shared(example: .CommonFeature, factory: .init(
            dependencies: [
                .shared(implements: .CommonFeature)
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
