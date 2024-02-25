//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/12/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let name = "Features"

let project = Project.makeModule(
    name: name,
    product: .staticFramework,
    targets: [.demo],
    includeResource: true,
    dependencies: [
        .commonFeature
    ]
)
