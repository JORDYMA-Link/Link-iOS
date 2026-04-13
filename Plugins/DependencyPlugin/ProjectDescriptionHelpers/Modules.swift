//
//  Modules.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/27/24.
//

import Foundation
import ProjectDescription

public enum ModulePath {
    case app(App)
    case feature(Feature)
    case designSystem(DesignSystem)
    case core(Core)
    case shared(Shared)
}

// MARK: AppModule

public extension ModulePath {
    enum App: String, CaseIterable {
        case iOS
        
        public static let name: String = "Blink"
    }
}

// MARK: FeatureModule

public extension ModulePath {
    enum Feature: String, CaseIterable {
        case StorageBox
        
        public static let name: String = "Feature"
    }
}

// MARK: DesignSystemModule

public extension ModulePath {
    enum DesignSystem: String, CaseIterable {
        case BKDesignSystem
        case BKDesignSystemThirdParty

        public static let name: String = "BKDesignSystem"
    }
}

// MARK: CoreModule

public extension ModulePath {
    enum Core: String, CaseIterable {
        case BKNetwork
        case Services

        public static let name: String = "Core"
    }
}

public extension ModulePath.Core {
    enum Clients: String, CaseIterable {
        case AnalyticsClient
        case AlertClient
        case ATTrackingManagerClient
        case UserNotificationClient
        case PasteboardClient
        case URLOpenHandlerClient
        case UserClient
        case AuthClient
        case FeedClient
        case FeedClientInterface
        case FolderClient
        case LinkClient
        case KakaoChannelClient
        case SocialLoginClient
        case NoticeClient

        public static let name: String = "Clients"
    }
}

// MARK: SharedModule

public extension ModulePath {
    enum Shared: String, CaseIterable {
        case BKCommon
        case BKModel
        case ThirdParty
        
        public static let name: String = "Shared"
    }
}
