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
    
    static let reactorKit = Package.remote(repo: "ReactorKit/ReactorKit", version: "3.2.0")
    static let rxSwift = Package.remote(repo: "ReactiveX/RxSwift", version: "6.6.0")
    static let moya = Package.remote(repo: "Moya/Moya", version: "15.0.0")
    static let snapkit = Package.remote(repo: "SnapKit/SnapKit", version: "5.6.0")
    static let then = Package.remote(repo: "devxoul/Then", version: "3.0.0")
    static let firebase = Package.remote(repo: "firebase/firebase-ios-sdk", version: "10.18.0")
    static let rxDatasources = Package.remote(repo: "RxSwiftCommunity/RxDataSources", version: "5.0.0")
    static let kingFisher = Package.remote(repo: "onevcat/Kingfisher", version: "7.9.1")
    static let fsCalendar = Package.remote(repo: "WenchaoD/FSCalendar", version: "2.8.3")
    static let lottie = Package.remote(repo: "airbnb/lottie-ios", version: "4.4.0")
}
