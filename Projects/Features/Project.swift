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
				.external(externalDependency: .composableArchitecture),
                .external(externalDependency: .introspect),
                .external(externalDependency: .kingFisher),
                .external(externalDependency: .swipeActions),
				.external(externalDependency: .lottie)
      ],
      settings: .settings(base: DefaultSetting.baseProductSetting)
    )
  ]
)
