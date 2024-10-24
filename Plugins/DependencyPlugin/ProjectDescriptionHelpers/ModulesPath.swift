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
        return .relativeToRoot("Projects/\(ModulePath.App.name)")
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
    static var domain: Self {
        return .relativeToRoot("Projects/\(ModulePath.Domain.name)")
    }
    
    static func domain(implementation module: ModulePath.Domain) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.Domain.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    static var data: Self {
        return .relativeToRoot("Projects/\(ModulePath.Data.name)")
    }
    
    static func data(implementation module: ModulePath.Data) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.Data.name)/\(module.rawValue)")
    }
}

public extension ProjectDescription.Path {
    static var core: Self {
        return .relativeToRoot("Projects/\(ModulePath.Core.name)")
    }
    
    static func core(implementation module: ModulePath.Core) -> Self {
        return .relativeToRoot("Projects/\(ModulePath.Core.name)/\(module.rawValue)")
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
