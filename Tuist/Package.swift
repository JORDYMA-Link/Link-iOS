// swift-tools-version: 5.9
@preconcurrency import PackageDescription

#if TUIST
@preconcurrency import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "ComposableArchitecture": .framework,
        "Moya": .staticLibrary,
        "FirebaseMessaging": .staticLibrary,
        "FirebaseAnalytics": .staticLibrary,
        "GoogleMobileAds": .staticLibrary,
        "Lottie": .framework,
        "Kingfisher": .framework,
        "SwiftUIIntrospect": .framework,
        "KakaoSDK": .framework,
        "FSCalendar": .framework,
        "FSPagerViewSwift": .framework,
        "GoogleSignInSwift": .framework
    ]
)
#endif

let package = Package(
    name: "blink",
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk", from: "12.7.0"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "12.14.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "8.6.2"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.5.2"),
        .package(url: "https://github.com/siteline/swiftui-introspect", from: "26.0.0"),
        .package(url: "https://github.com/Moya/Moya", from: "15.0.3"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.23.1"),
        .package(url: "https://github.com/kakao/kakao-ios-sdk", exact: "2.22.0"),
        .package(url: "https://github.com/WenchaoD/FSCalendar.git", from: "2.8.3"),
        .package(url: "https://github.com/kimkyuchul/FSPagerView-SPM", from: "1.3.5"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS.git", from: "9.0.0")
    ]
)
