//
//  Project.swift
//  ServiceLevelProjectManifests
//
//  Created by Kooky macBook Air on 2/8/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let name = "Data"

let project = Project.makeModule(
    name: name,
    product: .staticFramework, 
    targets: [],
    dependencies: [
        .SPM.moya,
        .Domain.repositoryInterface,
        .Domain.entity
    ]
)
