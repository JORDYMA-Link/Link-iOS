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
        .commonFeature,
        .data,
        .Domain.useCase,
        .Domain.entity,
        .core,
        .SPM.firebaseMessaging,
        .SPM.firebaseAnalytics
    ]
)
