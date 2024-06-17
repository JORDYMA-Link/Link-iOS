import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "CommonFeature",
  targets: [
    .make(
      name: "CommonFeature",
      product: .framework,
      bundleId: DefaultSetting.bundleId(moduleName: "commonFeature"),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .external(externalDependency: .lottie)
      ],
      settings: .settings(base: DefaultSetting.baseProductSetting)
    )
  ],
  resourceSynthesizers: [
    .custom(name: "JSON", parser: .json, extensions: ["json"]),
    .custom(name: "Lottie", parser: .json, extensions: ["lottie"]),
    .fonts(),
    .assets()
  ]
)
