@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Core.Clients.rawValue,
    targets: [
        .core(implements: .AnalyticsClient, factory: .init(
            sources: "AnalyticsClient/Sources/**",
            dependencies: [
                .shared,
                .external(externalDependency: .firebaseAnalytics)
            ]
        )),
        .core(implements: .UserClient, factory: .init(
            sources: "UserClient/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork)
            ]
        )),
        .core(implements: .AuthClient, factory: .init(
            sources: "AuthClient/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork)
            ]
        )),
        .core(implements: .FeedClientInterface, factory: .init(
            sources: "FeedClient/FeedClientInterface/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork)
            ]
        )),
        .core(implements: .FeedClient, factory: .init(
            sources: "FeedClient/FeedClient/Sources/**",
            dependencies: [
                .core(implements: .FeedClientInterface)
            ]
        )),
        .core(implements: .FolderClient, factory: .init(
            sources: "FolderClient/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork),
                .core(implements: .FeedClientInterface)
            ]
        )),
        .core(implements: .LinkClient, factory: .init(
            sources: "LinkClient/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork),
                .core(implements: .FeedClientInterface)
            ]
        )),
        .core(implements: .NoticeClient, factory: .init(
            sources: "NoticeClient/Sources/**",
            dependencies: [
                .core(implements: .BKNetwork)
            ]
        )),
    ]
)
