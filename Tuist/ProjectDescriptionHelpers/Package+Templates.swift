//
//  Package+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/8/24.
//

import ProjectDescription

public extension Package {
    private static func remote(repo: String, version: Version) -> Package {
        return Package.remote(url: "https://github.com/\(repo).git", requirement: .exact(version))
    }
    
    private static func remote(repo: String, branch: String) -> Package {
        return Package.remote(url: "https://github.com/\(repo).git", requirement: .branch(branch))
    }
    
    private static func remote(repo: String, upToNextMajor: Version) -> Package {
        return Package.remote(url: "https://github.com/\(repo).git", requirement: .upToNextMajor(from: upToNextMajor))
    }
    
    static let moya = Package.remote(repo: "Moya/Moya", version: "15.0.0")
    static let firebase = Package.remote(repo: "firebase/firebase-ios-sdk", version: "10.18.0")
    static let kingFisher = Package.remote(repo: "onevcat/Kingfisher", version: "7.9.1")
    static let lottie = Package.remote(repo: "airbnb/lottie-ios", version: "4.4.0")
    static let introspect = Package.remote(repo: "siteline/swiftui-introspect", branch: "main")
    static let keyboardObserving = Package.remote(repo: "nickffox/KeyboardObserving", branch: "master")
    static let swipeActions = Package.remote(repo: "aheze/SwipeActions", branch: "main")
    static let composableArchitecture = Package.remote(repo: "pointfreeco/swift-composable-architecture", version: "1.10.4")
}
