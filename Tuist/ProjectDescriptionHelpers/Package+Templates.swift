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
    
    static let swinject = Package.remote(repo: "Swinject/Swinject", version: "2.8.4")
    static let reactorKit = Package.remote(repo: "ReactorKit/ReactorKit", version: "3.2.0")
    static let rxSwift = Package.remote(repo: "ReactiveX/RxSwift", branch: "main")
    static let moya = Package.remote(repo: "Moya/Moya", branch: "master")
    static let snapkit = Package.remote(repo: "SnapKit/SnapKit", version: "5.6.0")
    static let firebase = Package.remote(repo: "firebase/firebase-ios-sdk", version: "10.18.0")
    static let kingFisher = Package.remote(repo: "onevcat/Kingfisher", version: "7.9.1")
    static let fsCalendar = Package.remote(repo: "WenchaoD/FSCalendar", version: "2.8.3")
    static let lottie = Package.remote(repo: "airbnb/lottie-ios", version: "4.4.0")
    static let panModal = Package.remote(repo: "slackhq/PanModal", upToNextMajor: "1.0.0")
    static let toaster = Package.remote(repo: "devxoul/Toaster", branch: "master")
}
