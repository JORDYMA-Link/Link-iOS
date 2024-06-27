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
                .project(target: .commonFeature, projectPath: .commonFeature),
                .project(target: .coreKit, projectPath: .core),
				.external(externalDependency: .composableArchitecture),
                .external(externalDependency: .introspect),
                .external(externalDependency: .kingFisher),
                .external(externalDependency: .swipeActions),
				.external(externalDependency: .lottie),
                .external(externalDependency: .FSCalendar)
      ],
      settings: .settings(base: DefaultSetting.baseProductSetting)
    )
  ]
)
