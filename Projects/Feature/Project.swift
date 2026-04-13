@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Feature.name,
    targets: [
        .feature(factory: .init(
            product: .staticFramework,
            sources: ["Scene/**"],
            dependencies: [
                .core,
                .designSystem,
                .external(externalDependency: .introspect),
                .external(externalDependency: .fSCalendar)
            ]
        ))
    ]
)
