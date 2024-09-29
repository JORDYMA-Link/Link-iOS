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
    case domain
    case core(Core)
    case shared(Shared)
}

// MARK: AppModule

public extension ModulePath {
    enum App: String, CaseIterable {
        case iOS
        
        public static let name: String = "App"
    }
}

// MARK: FeatureModule

public extension ModulePath {
    enum Feature: String, CaseIterable {
        case Login
        
        public static let name: String = "Feature"
    }
}

// MARK: FeatureModule

public extension ModulePath {
    enum Domain: String, CaseIterable {
        case Login
        
        public static let name: String = "Domain"
    }
}

// MARK: CoreModule

public extension ModulePath {
    enum Core: String, CaseIterable {
        case Models
        case Services
        
        public static let name: String = "Core"
    }
}

// MARK: SharedModule

public extension ModulePath {
    enum Shared: String, CaseIterable {
        case Common
        case CommonFeature
        case CommonFeatureThirdParty
        case ThirdParty
        
        public static let name: String = "Shared"
    }
}
