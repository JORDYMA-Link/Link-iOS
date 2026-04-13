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

// MARK: CoreModule

public extension ModulePath {
    enum Core: String, CaseIterable {
        case Analytics
        case BKNetwork
        case Services

        public static let name: String = "Core"
    }
}

// MARK: SharedModule

public extension ModulePath {
    enum Shared: String, CaseIterable {
        case BKCommon
        case BKModel
        case CommonFeature
        case CommonFeatureThirdParty
        case ThirdParty
        
        public static let name: String = "Shared"
    }
}
