//
//  Target+Template.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/27/24.
//

import Foundation
import ProjectDescription

// MARK: Target + Template

public struct TargetFactory {
    var name: String
    var destinations: Set<Destination>
    var product: Product
    var productName: String?
    var bundleId: String?
    var deploymentTarget: DeploymentTargets?
    var infoPlist: InfoPlist?
    var sources: SourceFilesList?
    var resources: ResourceFileElements?
    var copyFiles: [CopyFilesAction]?
    var headers: Headers?
    var entitlements: Entitlements?
    var scripts: [TargetScript]
    var dependencies: [TargetDependency]
    var settings: Settings?
    var coreDataModels: [CoreDataModel]
    var environmentVariables: [String: EnvironmentVariable]
    var launchArguments: [LaunchArgument]
    var additionalFiles: [FileElement]
    
    public init(
        name: String = "",
        destinations: Set<Destination> = [.iPhone],
        product: Product = .staticLibrary,
        productName: String? = nil,
        bundleId: String? = nil,
        deploymentTarget: DeploymentTargets? = nil,
        infoPlist: InfoPlist? = .default,
        sources: SourceFilesList? = .sources,
        resources: ResourceFileElements? = nil,
        copyFiles: [CopyFilesAction]? = nil,
        headers: Headers? = nil,
        entitlements: Entitlements? = nil,
        scripts: [TargetScript] = [],
        dependencies: [TargetDependency] = [],
        settings: Settings? = nil,
        coreDataModels: [CoreDataModel] = [],
        environmentVariables: [String: EnvironmentVariable] = [:],
        launchArguments: [LaunchArgument] = [],
        additionalFiles: [FileElement] = []) {
        self.name = name
        self.destinations = destinations
        self.product = product
        self.productName = productName
        self.deploymentTarget = DefaultSetting.DeploymentTargets
        self.bundleId = bundleId
        self.infoPlist = infoPlist
        self.sources = sources
        self.resources = resources
        self.copyFiles = copyFiles
        self.headers = headers
        self.entitlements = entitlements
        self.scripts = scripts
        self.dependencies = dependencies
        self.settings = settings
        self.coreDataModels = coreDataModels
        self.environmentVariables = environmentVariables
        self.launchArguments = launchArguments
        self.additionalFiles = additionalFiles
    }
}

public extension Target {
    private static func make(factory: TargetFactory) -> Self {
        return .target(
            name: factory.name,
            destinations: factory.destinations,
            product: factory.product,
            productName: factory.productName,
            bundleId: factory.bundleId ?? DefaultSetting.projectBundleId() + ".\(factory.name)",
            deploymentTargets: factory.deploymentTarget,
            infoPlist: factory.infoPlist,
            sources: factory.sources,
            resources: factory.resources,
            copyFiles: factory.copyFiles,
            headers: factory.headers,
            entitlements: factory.entitlements,
            scripts: factory.scripts,
            dependencies: factory.dependencies,
            settings: factory.settings,
            coreDataModels: factory.coreDataModels,
            environmentVariables: factory.environmentVariables,
            launchArguments: factory.launchArguments,
            additionalFiles: factory.additionalFiles
        )
    }
}

public extension Target {
    static func app(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = "Blink"
        newFactory.product = .app
        newFactory.bundleId = DefaultSetting.projectBundleId()
        newFactory.infoPlist = .file(path: .relativeToRoot("Projects/App/Info.plist"))
        newFactory.resources = ["Resources/**",
                                "Resources/GoogleService-Info.plist"
                               ]
        newFactory.entitlements = .file(path: .relativeToRoot("Projects/App/Blink.entitlements"))
        newFactory.scripts = [.firebaseCrashlytics]
        newFactory.settings = .appSettings
        
        return make(factory: newFactory)
    }
}

// MARK: Target + Domain

public extension Target {
    static func domain(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name
        
        return make(factory: newFactory)
    }
    
    static func domain(implements module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue
        
        return make(factory: newFactory)
    }
    
    static func domain(tests module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Tests"
        newFactory.product = .unitTests
        newFactory.sources = .tests
        
        return make(factory: newFactory)
    }
    
    static func domain(testing module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Testing"
        newFactory.sources = .testing
        
        return make(factory: newFactory)
    }
    
    static func domain(interface module: ModulePath.Domain, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Domain.name + module.rawValue + "Interface"
        newFactory.sources = .interface
        
        return make(factory: newFactory)
    }
}

public extension Target {
    static func core(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Core.name
        
        return make(factory: newFactory)
    }
    
    static func core(implements module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
//        newFactory.name = ModulePath.Core.name + module.rawValue
        newFactory.name = module.rawValue
                
        return make(factory: newFactory)
    }
    
    static func core(interface module: ModulePath.Core, factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = module.rawValue + "Interface"
        newFactory.sources = .interface
        
        return make(factory: newFactory)
    }
}

public extension Target {
    static func shared(factory: TargetFactory) -> Self {
        var newFactory = factory
        newFactory.name = ModulePath.Shared.name
        
        return make(factory: newFactory)
    }
    
    static func shared(implements module: ModulePath.Shared, factory: TargetFactory) -> Self {
        var newFactory = factory
//        newFactory.name = ModulePath.Shared.name + module.rawValue
        newFactory.name = module.rawValue
        
        if module == .CommonFeature {
            newFactory.sources = .sources
            newFactory.resources = ["Resources/**"]
            newFactory.product = .staticFramework
        }
                
        return make(factory: newFactory)
    }
}
