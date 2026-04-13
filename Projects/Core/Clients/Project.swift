@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Core.Clients.name,
    targets: [
        .core(client: .AnalyticsClient, factory: .init(
            sources: "AnalyticsClient/Sources/**",
            dependencies: [
                .shared,
                .external(externalDependency: .firebaseAnalytics)
            ]
        )),
        .core(client: .AlertClient, factory: .init(
            sources: "AlertClient/Sources/**",
            dependencies: [
                .shared,
                .designSystem
            ]
        )),
        .core(client: .ATTrackingManagerClient, factory: .init(
            sources: "ATTrackingManagerClient/Sources/**",
            dependencies: [
                .shared
            ]
        )),
        .core(client: .UserNotificationClient, factory: .init(
            sources: "UserNotificationClient/Sources/**",
            dependencies: [
                .shared
            ]
        )),
        .core(client: .PasteboardClient, factory: .init(
            sources: "PasteboardClient/Sources/**",
            dependencies: [
                .shared
            ]
        )),
        .core(client: .URLOpenHandlerClient, factory: .init(
            sources: "URLOpenHandlerClient/Sources/**",
            dependencies: [
                .shared
            ]
        )),
        .core(client: .UserClient, factory: .init(
            sources: "UserClient/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork)
            ]
        )),
        .core(client: .AuthClient, factory: .init(
            sources: "AuthClient/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork)
            ]
        )),
        .core(client: .FeedClientInterface, factory: .init(
            sources: "FeedClient/FeedClientInterface/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork)
            ]
        )),
        .core(client: .FeedClient, factory: .init(
            sources: "FeedClient/FeedClient/Sources/**",
            dependencies: [
                .core(client: .FeedClientInterface)
            ]
        )),
        .core(client: .FolderClient, factory: .init(
            sources: "FolderClient/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork),
                .core(client: .FeedClientInterface)
            ]
        )),
        .core(client: .LinkClient, factory: .init(
            sources: "LinkClient/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork),
                .core(client: .FeedClientInterface)
            ]
        )),
        .core(client: .KakaoChannelClient, factory: .init(
            sources: "KakaoChannelClient/Sources/**",
            dependencies: [
                .shared,
                .external(externalDependency: .kakaoSDKTalk)
            ]
        )),
        .core(client: .SocialLoginClient, factory: .init(
            sources: "SocialLoginClient/Sources/**",
            dependencies: [
                .shared,
                .external(externalDependency: .googleSignIn),
                .external(externalDependency: .kakaoSDKAuth),
                .external(externalDependency: .kakaoSDKCommon),
                .external(externalDependency: .kakaoSDKUser)
            ]
        )),
        .core(client: .GoogleMobileAdsClient, factory: .init(
            sources: "GoogleMobileAdsClient/Sources/**",
            dependencies: [
                .shared,
                .external(externalDependency: .googleMobileAds)
            ]
        )),
        .core(client: .NoticeClient, factory: .init(
            sources: "NoticeClient/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork)
            ]
        )),
    ]
)
