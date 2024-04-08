//
//  XCConfig+Templates.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/23/24.
//

import ProjectDescription

public struct XCConfig {
    private struct Path {
        static func project(_ config: String) -> ProjectDescription.Path { .relativeToRoot("XCConfig/App/\(config).xcconfig") }
    }
    
    public static let project: [Configuration] = [
        .debug(name: .debug, xcconfig: Path.project("DEV")),
        .release(name: .release, xcconfig: Path.project("PROD")),
    ]
}
