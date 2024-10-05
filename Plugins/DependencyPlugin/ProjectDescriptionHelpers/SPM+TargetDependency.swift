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
    case kingFisher = "Kingfisher"
    case lottie = "Lottie"
    case introspect = "SwiftUIIntrospect"
    case composableArchitecture = "ComposableArchitecture"
    case kakaoSDK = "KakaoSDK"
    case FSCalendar = "FSCalendar"
}
