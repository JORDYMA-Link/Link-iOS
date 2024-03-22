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
        .SPM.rxSwift,
        .SPM.reactorKit,
        .SPM.fsCalendar,
        .SPM.kingFisher,
        .SPM.lottie,
        .SPM.snapkit,
        .SPM.panModal,
        .SPM.toaster,
        .Carthage.realm,
        .Carthage.realmSwift
    ]
)
