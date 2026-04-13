//
//  ModulesPath.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/27/24.
//

import Foundation
import ProjectDescription

public extension ProjectDescription.Path {
    static var app: Self {
        return .relativeToRoot("Projects/App")
    }
}

public extension ProjectDescription.Path {
    static var feature: Self {
        return .relativeToRoot("Projects/\(ModulePath.Feature.name)")
    }
    
    static func feature(implementation module: ModulePath.Feature) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.Feature.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    static var designSystem: Self {
        return .relativeToRoot("Projects/\(ModulePath.DesignSystem.name)")
    }

    static func designSystem(implementation module: ModulePath.DesignSystem) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.DesignSystem.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    static var core: Self {
        return .relativeToRoot("Projects/\(ModulePath.Core.name)")
    }

    static func core(implementation module: ModulePath.Core) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.Core.name)/\(module.rawValue)")
    }

    static func client(implementation module: ModulePath.Core.Clients) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.Core.name)/\(ModulePath.Core.Clients.name)")
    }
}

public extension ProjectDescription.Path {
    static var shared: Self {
        return .relativeToRoot("Projects/\(ModulePath.Shared.name)")
    }
    
    static func shared(module: ModulePath.Shared) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.Shared.name)/\(module.rawValue)")
    }
}
