//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/29/24.
//

import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
    name: ModulePath.Shared.CommonFeature.rawValue,
    targets: [
        .shared(implements: .CommonFeature, factory: .init(
            dependencies: [
                .shared(implements: .CommonFeatureThirdParty)
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
