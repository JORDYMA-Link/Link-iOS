//
//  TargetDependency+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/8/24.
//

import ProjectDescription

public extension TargetDependency {

    static let core = TargetDependency.project(
        target: "Core",
        path: .relativeToRoot("./Modules/Core")
    )
    
    class Core {
        public static let thirdPartyLib = TargetDependency.project(
            target: "ThirdPartyLib",
            path: .relativeToRoot("./Modules/Core/ThirdPartyLib")
        )
        
        public static let util = TargetDependency.project(
            target: "Util",
            path: .relativeToRoot("./Modules/Core/Util")
        )
        
        public static let networking = TargetDependency.project(
            target: "Networking",
            path: .relativeToRoot("./Modules/Core/Network")
        )
        
        public static let designSystem = TargetDependency.project(
            target: "DesignSystem",
            path: .relativeToRoot("./Modules/Core/DesignSystem")
        )
    }
    
    static let data = TargetDependency.project(
        target: "Data",
        path: .relativeToRoot("./Modules/Data")
    )
        
    static let domain = TargetDependency.project(
        target: "Domain",
        path: .relativeToRoot("./Modules/Domain")
    )
    
    class Domain {
        public static let useCase = TargetDependency.project(
            target: "UseCase",
            path: .relativeToRoot("./Modules/Domain/UseCase")
        )
        
        public static let entity = TargetDependency.project(
            target: "Entity",
            path: .relativeToRoot("./Modules/Domain/Entity")
        )
        
        public static let repositoryInterface = TargetDependency.project(
            target: "RepositoryInterface",
            path: .relativeToRoot("./Modules/Domain/RepositoryInterface")
        )
    }
    
    static let commonFeature = TargetDependency.project(
        target: "CommonFeature",
        path: .relativeToRoot("./Modules/CommonFeature")
    )
    
    class Feature {
        public static let features = TargetDependency.project(
            target: "Features",
            path: .relativeToRoot("./Modules/Features")
        )
    }
    
    class SPM {
        public static let moya = TargetDependency.external(name: "Moya")
        public static let combineMoya = TargetDependency.external(name: "CombineMoya")
        public static let firebaseMessaging = TargetDependency.external(name: "FirebaseMessaging")
        public static let firebaseAnalytics = TargetDependency.external(name: "FirebaseAnalytics")
        public static let kingFisher = TargetDependency.external(name: "Kingfisher")
        public static let fsCalendar = TargetDependency.external(name: "FSCalendar")
        public static let lottie = TargetDependency.external(name: "Lottie")
        public static let introspect = TargetDependency.external(name: "SwiftUIIntrospect")
        public static let keyboardObserving = TargetDependency.external(name: "KeyboardObserving")
    }
    
    class Carthage {
        public static let realm = TargetDependency.external(name: "Realm")
        public static let realmSwift = TargetDependency.external(name: "RealmSwift")
    }
}
