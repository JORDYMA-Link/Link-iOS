//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/29/24.
//

import ProjectDescription
import ProjectDescriptionHelpers


let project = Project.make(
    name: ModulePath.Shared.Common.rawValue,
    targets: [
        .shared(implements: .Common, factory: .init())
    ]
)
