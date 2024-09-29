import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Blink",
    targets: [
        .app(factory: .init(
            dependencies: [
                .project(target: .features, projectPath: .features)
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
