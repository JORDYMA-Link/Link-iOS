// swift-tools-version: 5.9
import PackageDescription

#if TUIST
  import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "ComposableArchitecture": .framework,
        "Moya": .framework,
        "FirebaseMessaging": .staticLibrary,
        "FirebaseAnalytics": .staticLibrary,
        "Lottie": .framework,
        "Kingfisher": .framework,
        "SwiftUIIntrospect": .framework,
        "KakaoSDK": .framework,
        "FSCalendar": .framework
    ]
)
#endif

let package = Package(
    name: "blink",
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "11.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.9.1"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.4.3"),
        .package(url: "https://github.com/siteline/swiftui-introspect", exact: "1.3.0"),
        .package(url: "https://github.com/Moya/Moya", from: "15.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "1.11.0"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", exact: "2.22.0"),
        .package(url: "https://github.com/WenchaoD/FSCalendar.git", from: "2.8.4")
    ]
)
