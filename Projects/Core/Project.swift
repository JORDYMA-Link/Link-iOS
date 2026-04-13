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
    name: ModulePath.Core.name,
    targets: [
        .core(factory: .init(
            product: .staticFramework,
            sources: nil,
            dependencies: [
                .core(implements: .AnalyticsClient),
                .core(implements: .Services),
                .core(implements: .UserClient),
                .core(implements: .AuthClient),
                .core(implements: .FeedClient),
                .core(implements: .FolderClient),
                .core(implements: .LinkClient),
                .core(implements: .NoticeClient)
            ]
        ))
    ]
)

