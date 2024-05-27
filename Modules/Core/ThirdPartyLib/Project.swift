//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/12/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let name = "ThirdPartyLib"

let project = Project.makeModule(
    name: name,
    product: .framework,
    targets: [],
    dependencies: [
        .SPM.composableArchitecture,
        .SPM.kingFisher,
        .SPM.lottie,
        .SPM.introspect,
        .SPM.keyboardObserving,
        .SPM.swipeActions,
        .Carthage.realm,
        .Carthage.realmSwift
    ]
)
