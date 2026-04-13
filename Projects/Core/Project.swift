//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 6/14/24.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.make(
    name: ModulePath.Core.name,
    targets: [
        .core(factory: .init(
            product: .staticFramework,
            sources: nil,
            dependencies: [
                .core(client: .AnalyticsClient),
                .core(client: .AlertClient),
                .core(client: .ATTrackingManagerClient),
                .core(client: .UserNotificationClient),
                .core(client: .PasteboardClient),
                .core(client: .URLOpenHandlerClient),
                .core(client: .GoogleMobileAdsClient),
                .core(client: .UserClient),
                .core(client: .AuthClient),
                .core(client: .FeedClient),
                .core(client: .FolderClient),
                .core(client: .LinkClient),
                .core(client: .KakaoChannelClient),
                .core(client: .SocialLoginClient),
                .core(client: .NoticeClient)
            ]
        ))
    ]
)

