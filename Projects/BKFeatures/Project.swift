@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Feature.name,
    targets: [
        .feature(factory: .init(
            product: .staticFramework,
            sources: ["Sources/**"],
            dependencies: [
                .core,
                .designSystem,
                .external(externalDependency: .composableArchitecture),
                .external(externalDependency: .introspect),
                .external(externalDependency: .fSCalendar)
            ]
        ))
    ]
)
