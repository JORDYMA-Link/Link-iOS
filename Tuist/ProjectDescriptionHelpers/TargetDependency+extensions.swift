import Foundation
import ProjectDescription

extension TargetDependency {
  public static func external(externalDependency: ExternalDependency) -> TargetDependency {
    return .external(name: externalDependency.rawValue)
  }

  public static func target(name: TargetName) -> TargetDependency {
    return .target(name: name.rawValue)
  }

  public static func project(target: TargetName, projectPath: ProjectPath) -> TargetDependency {
    return .project(
      target: target.rawValue,
      path: .relativeToRoot(projectPath.rawValue)
    )
  }
}

public enum ProjectPath: String {
  case core = "Projects/Core"
  case commonFeature = "Projects/CommonFeature"
  case features = "Projects/Features"
}

public enum TargetName: String {
  case models = "Models"
  case services = "Services"
  case common = "Common"
  case coreKit = "CoreKit"
  case commonFeature = "CommonFeature"
  case features = "Features"
}

public enum ExternalDependency: String {
    case moya = "Moya"
    case firebaseMessaging = "FirebaseMessaging"
    case firebaseAnalytics = "FirebaseAnalytics"
    case kingFisher = "Kingfisher"
    case lottie = "Lottie"
    case introspect = "SwiftUIIntrospect"
    case swipeActions = "SwipeActions"
    case composableArchitecture = "ComposableArchitecture"
    case kakaoSDK = "KakaoSDK"
}
