//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 6/14/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

// 출시 이전 framework로 사용
// 1.0.0 배포 전 staticLibrary로 변경하기
let project = Project.make(
    name: "Core",
    targets: [
        .make(
            name: "Models",
            product: .framework,
            bundleId: DefaultSetting.bundleId(moduleName: "models"),
            sources: ["Models/**"],
            dependencies: []
        ),
        .make(
            name: "Services",
            product: .framework,
            bundleId: DefaultSetting.bundleId(moduleName: "services"),
            sources: ["Services/**"],
            dependencies: [
                .target(name: .models),
                .external(externalDependency: .composableArchitecture),
                .external(externalDependency: .kakaoSDK),
                .external(externalDependency: .moya)
            ]
        ),
        .make(
            name: "Common",
            product: .framework,
            bundleId: DefaultSetting.bundleId(moduleName: "common"),
            sources: ["Common/**"],
            dependencies: []
        )
    ]
)

