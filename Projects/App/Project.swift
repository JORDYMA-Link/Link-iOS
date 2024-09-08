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
            name: "Blink",
            product: .app,
            bundleId: DefaultSetting.projectBundleId(),
            infoPlist: .file(path: .relativeToRoot("Projects/App/Info.plist")),
            sources: ["Sources/**"],
            resources: ["Resources/**",
                        "Resources/GoogleService-Info.plist"
                       ],
            entitlements: .file(path: .relativeToRoot("Projects/App/Blink.entitlements")),
            dependencies: [
                .project(target: .features, projectPath: .features),
                .project(target: .commonFeature, projectPath: .commonFeature),
                .project(target: .services, projectPath: .core),
                .external(externalDependency: .composableArchitecture),
                .package(product: "FirebaseMessaging")
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "LQ5JVAULLP",
                    "CODE_SIGN_STYLE": "Manual",
                    "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                    "OTHER_LDFLAGS": "$(inherited) -ObjC",
                    "ENABLE_BITCODE": "NO"
                ],
                configurations: [
                    .release(
                        name: .release,
                        settings: [
                            "ASSETCATALOG_COMPILER_APPICON_NAME": "ReleaseAppIcon"
                        ],
                        xcconfig: "./xcconfigs/Blink.release.xcconfig"),
                    .debug(
                        name: .debug,
                        settings: [
                            "ASSETCATALOG_COMPILER_APPICON_NAME": "DevAppIcon"
                        ],
                        xcconfig: "./xcconfigs/Blink.debug.xcconfig")
                ]
            )
        ),
    ],
    additionalFiles: [
        "./xcconfigs/Blink.shared.xcconfig",
        "./xcconfigs/APIKey.xcconfig"
    ]
)
