import Foundation
import ProjectDescription

extension TargetDependency {
    public static func external(externalDependency: ExternalDependency) -> TargetDependency {
        return .external(name: externalDependency.rawValue)
    }
}

public enum ExternalDependency: String {
    case moya = "Moya"
    case firebaseMessaging = "FirebaseMessaging"
    case firebaseAnalytics = "FirebaseAnalytics"
    case googleMobileAds = "GoogleMobileAds"
    case kingFisher = "Kingfisher"
    case lottie = "Lottie"
    case introspect = "SwiftUIIntrospect"
    case composableArchitecture = "ComposableArchitecture"
    case dependencies = "Dependencies"
    case dependenciesMacros = "DependenciesMacros"
    case perception = "Perception"
    case kakaoSDK = "KakaoSDK"
    case kakaoSDKTalk = "KakaoSDKTalk"
    case kakaoSDKAuth = "KakaoSDKAuth"
    case kakaoSDKCommon = "KakaoSDKCommon"
    case kakaoSDKUser = "KakaoSDKUser"
    case fSCalendar = "FSCalendar"
    case fSPagerViewSwift = "FSPagerViewSwift"
    case googleSignIn = "GoogleSignIn"
}
