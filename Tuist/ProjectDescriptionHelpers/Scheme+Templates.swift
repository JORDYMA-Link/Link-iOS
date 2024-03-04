//
//  Scheme+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/12/24.
//

import ProjectDescription

extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }

    static func makeDemoScheme(target: ConfigurationName, name: String) -> Scheme {
        return Scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)Demo"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)Demo"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}

extension Project {
    static let appScheme: [Scheme] = [
        Scheme(name: "\(DefaultSetting.appIdentifier)-Debug",
              buildAction: .buildAction(targets: ["\(DefaultSetting.appIdentifier)"]),
              runAction: .runAction(configuration: .debug),
              archiveAction: .archiveAction(configuration: .debug),
              profileAction: .profileAction(configuration: .debug),
              analyzeAction: .analyzeAction(configuration: .debug)
             ),
        Scheme(name: "\(DefaultSetting.appIdentifier)-Release",
              buildAction: .buildAction(targets: ["\(DefaultSetting.appIdentifier)"]),
              runAction: .runAction(configuration: .release),
              archiveAction: .archiveAction(configuration: .release),
              profileAction: .profileAction(configuration: .release),
              analyzeAction: .analyzeAction(configuration: .release)
             )
    ]
}
