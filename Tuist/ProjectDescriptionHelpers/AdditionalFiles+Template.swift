//
//  AdditionalFiles+Template.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/27/24.
//

import Foundation
import ProjectDescription

public extension ProjectDescription.FileElement {
    static var sharedFileElement: Self {
        return "./xcconfigs/Blink.shared.xcconfig"
    }
    
    static var apiKeyFileElement: Self {
        return "./xcconfigs/APIKey.xcconfig"
    }
}
