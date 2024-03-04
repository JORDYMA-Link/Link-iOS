//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/12/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let name = "Core"

let project = Project.makeModule(
    name: name,
    product: .framework,
    targets: [],
    dependencies: [
        .Core.thirdPartyLib,
        .Core.util
    ]
)
