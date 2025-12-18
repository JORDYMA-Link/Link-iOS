@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.App.name,
    targets: [
        .app(factory: .init(
            dependencies: [
                .feature,
                .shared(implements: .ThirdParty),
                .target(name: "ShareExtension")
            ]
        )),
        .shareExtension(factory: .init(
            dependencies: [
                .core(implements: .BKNetwork)
            ]
        ))
    ],
    schemes: [
      .scheme(
        name: "Release-Blink",
        buildAction: .buildAction(targets: ["Blink"]),
        runAction: .runAction(
          configuration: .release,
          arguments: .arguments(environmentVariables: ["IDEPreferLogStreaming": "YES"])
        ),
        archiveAction: .archiveAction(configuration: .release),
        profileAction: .profileAction(configuration: .release),
        analyzeAction: .analyzeAction(configuration: .release)
      ),
      .scheme(
        name: "Dev-Blink",
        buildAction: .buildAction(targets: ["Blink"]),
        runAction: .runAction(
          configuration: .debug,
          arguments: .arguments(environmentVariables: ["IDEPreferLogStreaming": "YES"])
        ),
        archiveAction: .archiveAction(configuration: .debug),
        profileAction: .profileAction(configuration: .debug),
        analyzeAction: .analyzeAction(configuration: .debug)
      )
    ],
    additionalFiles: [
        .sharedFileElement,
        .apiKeyFileElement
    ]
)

