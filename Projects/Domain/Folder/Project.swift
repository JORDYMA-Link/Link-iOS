//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 10/18/24.
//

import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Domain.name+ModulePath.Domain.Folder.rawValue,
    targets: [
        .domain(
            interface: .Folder,
            factory: .init(
                dependencies: [
                    .core
                ]
            )
        ),
        .domain(
            implements: .Folder,
            factory: .init(
                dependencies: [
                    .domain(interface: .Folder)
                ]
            )
        ),
        .domain(
            testing: .Folder,
            factory: .init(
                dependencies: [
                    .domain(interface: .Folder)
                ]
            )
        ),
        .domain(
            tests: .Folder,
            factory: .init(
                dependencies: [
                    .domain(testing: .Folder),
                    .domain(implements: .Folder)
                ]
            )
        ),
    ]
)
