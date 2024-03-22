//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 김규철 on 2024/01/09.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: DefaultSetting.appIdentifier,
    dependencies: [
        .Feature.features,
        .Domain.entity,
        .Domain.repositoryInterface,
        .Domain.useCase,
        .data,
        .SPM.firebaseMessaging,
        .SPM.firebaseAnalytics,
        .SPM.swinject
    ]
)
