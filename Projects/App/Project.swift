import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.make(
  name: "App",
  packages: [
    .remote(
        url: "https://github.com/firebase/firebase-ios-sdk",
        requirement: .exact("10.27.0"))
  ],
  targets: [
    .make(
      name: "Release-Blink",
      product: .app,
      bundleId: DefaultSetting.projectBundleId(),
      infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: .coreKit, projectPath: .core),
        .project(target: .features, projectPath: .features),
        .project(target: .commonFeature, projectPath: .commonFeature),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .kakaoSDK),
        .package(product: "FirebaseMessaging")
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_APPICON_NAME": "ReleaseAppIcon",
          "DEVELOPMENT_TEAM": "8LJ2P85FNV",
          "CODE_SIGN_STYLE": "Manual",
          "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
          "OTHER_LDFLAGS": "$(inherited) -ObjC",
          "ENABLE_BITCODE": "NO"
//          "PROVISIONING_PROFILE_SPECIFIER": "match Development com.mashup.gabbangzip",
//          "CODE_SIGN_IDENTITY": "Apple Development: Hyerin Choe (QKKN56KGD9)"
        ],
        configurations: [
          .release(name: .release, xcconfig: "./xcconfigs/Blink.release.xcconfig")
        ]
      )
    ),
    .make(
      name: "Dev-Blink",
      product: .app,
      bundleId: DefaultSetting.projectBundleId(isDev: true),
      infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
      sources: ["Sources/**"],
      resources: ["Resources/**"],
      dependencies: [
        .project(target: .coreKit, projectPath: .core),
        .project(target: .features, projectPath: .features),
        .project(target: .commonFeature, projectPath: .commonFeature),
        .external(externalDependency: .composableArchitecture),
        .external(externalDependency: .kakaoSDK),
        .package(product: "FirebaseMessaging")
      ],
      settings: .settings(
        base: [
          "ASSETCATALOG_COMPILER_APPICON_NAME": "DevAppIcon",
          "DEVELOPMENT_TEAM": "8LJ2P85FNV",
          "CODE_SIGN_STYLE": "Manual",
          "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
          "OTHER_LDFLAGS": "$(inherited) -ObjC",
          "ENABLE_BITCODE": "NO"
//          "PROVISIONING_PROFILE_SPECIFIER": "match Development com.mashup.gabbangzip-dev",
//          "CODE_SIGN_IDENTITY": "Apple Development: Hyerin Choe (QKKN56KGD9)"
        ],
        configurations: [
          .debug(name: .debug, xcconfig: "./xcconfigs/Blink.debug.xcconfig")
        ]
      )
    ),
  ],
  
  additionalFiles: [
    "./xcconfigs/Blink.shared.xcconfig"
  ]
)
