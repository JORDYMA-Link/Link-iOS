import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
    name: "Features",
    targets: [
        .make(
            name: "Features",
            product: .framework,
            bundleId: DefaultSetting.bundleId(moduleName: "features"),
            sources: ["Scene/**"],
            dependencies: [
                .core
            ],
            settings: .settings(base: DefaultSetting.baseProductSetting)
        )
    ]
)
