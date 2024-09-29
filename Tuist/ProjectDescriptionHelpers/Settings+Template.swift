//
//  Settings+Template.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/27/24.
//

import Foundation
import ProjectDescription

public extension ProjectDescription.Settings {
    static var appSettings: Self {
        return .settings(
            base: [
                "DEVELOPMENT_TEAM": "LQ5JVAULLP",
                "CODE_SIGN_STYLE": "Manual",
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                "OTHER_LDFLAGS": "$(inherited) -ObjC",
                "ENABLE_BITCODE": "NO"
            ],
            configurations: [
                .release(name: .release,settings: [
                    "ASSETCATALOG_COMPILER_APPICON_NAME": "ReleaseAppIcon"],xcconfig: "./xcconfigs/Blink.release.xcconfig"),
                .debug(name: .debug, settings: ["ASSETCATALOG_COMPILER_APPICON_NAME": "DevAppIcon"], xcconfig: "./xcconfigs/Blink.debug.xcconfig")
            ]
        )
    }
    
    static var projectSettings: Self {
        return .settings(
            base: ["OTHER_LDFLAGS": "$(inherited) -ObjC",
                   "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                   "ENABLE_BITCODE": "NO"
                  ],
            configurations: [
                .release(name: .release,xcconfig: "./xcconfigs/Blink.release.xcconfig"),
                .debug(name: .debug, xcconfig: "./xcconfigs/Blink.debug.xcconfig")
            ]
        )
    }
    
    static var targetSettings: Self {
        return .settings(
            base: [
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym",
                "OTHER_LDFLAGS": "$(inherited) -ObjC",
            ],
            configurations: [
                .release(name: .release, xcconfig: "./xcconfigs/Blink.release.xcconfig"),
                .debug(name: .debug, xcconfig: "./xcconfigs/Blink.debug.xcconfig")
            ]
        )
    }
}
