//
//  Dependencies.swift
//  Config
//
//  Created by Kooky macBook Air on 1/7/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let dependencies = Dependencies(
    carthage: [
        .github(path: "realm/realm-swift", requirement: .upToNext("10.46.0"))
    ],
    swiftPackageManager: SwiftPackageManagerDependencies([
        .swinject,
        .reactorKit,
        .rxSwift,
        .moya,
        .snapkit,
        .kingFisher,
        .fsCalendar,
        .lottie,
        .panModal,
        .toaster,
        .firebase
    ],
                                                         productTypes: [
                                                            "Lottie" : .framework
                                                         ],
                                                         baseSettings: .settings(configurations: [
                                                            .debug(name: .debug),
                                                            .release(name: .release)
                                                         ]
                                                         )
    ),
    platforms: [.iOS]
)

