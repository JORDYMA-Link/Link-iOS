//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 6/14/24.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Shared.BKModel.rawValue,
    targets: [
        .shared(implements: .BKModel, factory: .init(
            dependencies: [
                .shared(implements: .BKCommon)
            ]
        ))
    ]
)

