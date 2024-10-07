//
//  SourceFilesList+Template.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/27/24.
//

import Foundation
import ProjectDescription

public extension SourceFilesList {
    static let exampleSources: SourceFilesList = "Example/Sources/**"
    static let interface: SourceFilesList = "Interface/Sources/**"
    static let sources: SourceFilesList = "Sources/**"
    static let testing: SourceFilesList = "Testing/Sources/**"
    static let tests: SourceFilesList = "Tests/Sources/**"
}
