//
//  Modules+TargetDependency.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/27/24.
//

import Foundation
import ProjectDescription

public extension TargetDependency {
    static var app: Self {
        return .project(target: ModulePath.App.name, path: .app)
    }
    
    // App 모듈에 ShareExtension, watch 등 앱 타겟 추가 시 사용
    static func app(implements module: ModulePath.App) -> Self {
        return .target(name: ModulePath.App.name + module.rawValue)
    }
}

public extension TargetDependency {
    static var feature: Self {
        return .project(target: ModulePath.Feature.name, path: .feature)
    }
    
    static func feature(implements module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue, path: .feature(implementation: module))
    }
    
    static func feature(interface module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Interface", path: .feature(implementation: module))
    }
    
    static func feature(tests module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Tests", path: .feature(implementation: module))
    }
    
    static func feature(testing module: ModulePath.Feature) -> Self {
        return .project(target: ModulePath.Feature.name + module.rawValue + "Testing", path: .feature(implementation: module))
    }
}

public extension TargetDependency {
    static var domain: Self {
        return .project(target: ModulePath.Domain.name, path: .domain)
    }
    
    static func domain(implements module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue, path: .domain(implementation: module))
    }
    
    static func domain(interface module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue + "Interface", path: .domain(implementation: module))
    }
    
    static func domain(tests module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue + "Tests", path: .domain(implementation: module))
    }
    
    static func domain(testing module: ModulePath.Domain) -> Self {
        return .project(target: ModulePath.Domain.name + module.rawValue + "Testing", path: .domain(implementation: module))
    }
}

public extension TargetDependency {
    static var data: Self {
        return .project(target: ModulePath.Data.name, path: .data)
    }
    
    static func data(implements module: ModulePath.Data) -> Self {
        return .project(target: ModulePath.Data.name + module.rawValue, path: .data(implementation: module))
    }
    
    static func data(interface module: ModulePath.Data) -> Self {
        return .project(target: ModulePath.Data.name + module.rawValue + "Interface", path: .data(implementation: module))
    }
    
    static func data(tests module: ModulePath.Data) -> Self {
        return .project(target: ModulePath.Data.name + module.rawValue + "Tests", path: .data(implementation: module))
    }
    
    static func data(testing module: ModulePath.Data) -> Self {
        return .project(target: ModulePath.Data.name + module.rawValue + "Testing", path: .data(implementation: module))
    }
}

public extension TargetDependency {
    static var core: Self {
        return .project(target: ModulePath.Core.name, path: .core)
    }
    
//    static func core(implements module: ModulePath.Core) -> Self {
//        return .project(target: ModulePath.Core.name + module.rawValue, path: .core(implementation: module))
    
    static func core(implements module: ModulePath.Core) -> Self {
        return .project(target: module.rawValue, path: .core(implementation: module))
    }
}


public extension TargetDependency {
    static var shared: Self {
        return .project(target: ModulePath.Shared.name, path: .shared)
    }
    
//    static func shared(implements module: ModulePath.Shared) -> Self {
//        return .project(target: ModulePath.Shared.name + module.rawValue, path: .shared(module: module))
    
    static func shared(implements module: ModulePath.Shared) -> Self {
        return .project(target: module.rawValue, path: .shared(module: module))
    }
}
