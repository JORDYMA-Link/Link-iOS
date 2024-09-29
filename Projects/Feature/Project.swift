import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Feature.name,
    targets: [
        .feature(factory: .init(
            product: .framework,
            sources: ["Scene/**"],
            dependencies: [
                .core
            ]
        ))
    ]
)
