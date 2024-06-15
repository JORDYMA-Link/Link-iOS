// swift-tools-version: 5.9
import PackageDescription

#if TUIST
  import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "ComposableArchitecture": .framework,
        "Moya": .framework,
        "FirebaseMessaging": .framework,
        "FirebaseAnalytics": .framework,
        "Lottie": .framework,
        "Kingfisher": .framework,
        "SwiftUIIntrospect": .framework,
        "SwipeActions": .framework,
        "KakaoSDK": .framework
    ]
)
#endif

let package = Package(
    name: "blink",
    dependencies: [
//        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "10.27.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.9.1"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.3"),
        .package(url: "https://github.com/siteline/swiftui-introspect", branch: "main"),
        .package(url: "https://github.com/aheze/SwipeActions", branch: "main"),
        .package(url: "https://github.com/Moya/Moya", from: "15.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.8.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", exact: "2.22.0")
    ]
)
