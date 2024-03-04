//
//  DefaultSetting.swift
//  ProjectDescriptionHelpers
//
//  Created by Kooky macBook Air on 2/8/24.
//

import ProjectDescription

public struct DefaultSetting {
    public static let targetVersion: SettingValue = "15.0"
    public static let organizaationName = "jordyma"
    public static let appIdentifier = "Link"
    public static let baseProductSetting: SettingsDictionary = SettingsDictionary()
        .debugInformationFormat(DebugInformationFormat.dwarfWithDsym)
        .otherLinkerFlags(["$(inherited) -ObjC"])
        .bitcodeEnabled(false)
}

public extension DefaultSetting {
    static func bundleId(moduleName: String) -> String {
        return "com.\(organizaationName).\(moduleName)"
    }
}

public extension SettingValue {
    var stringValue: String {
        switch self {
        case .string(let string):
            return string
            
        case .array(let array):
            guard let value = array.first else { return "" }
            return value
            
        @unknown default:
            return ""
        }
    }
}

public extension SettingsDictionary {
    func setCodeSignManual() -> SettingsDictionary {
        merging(["CODE_SIGN_STYLE": SettingValue(stringLiteral: "Manual")])
            .merging(["DEVELOPMENT_TEAM": SettingValue(stringLiteral: "9K86FQHDLU")])
            .merging(["CODE_SIGN_IDENTITY": SettingValue(stringLiteral: "$(CODE_SIGN_IDENTITY)")])
    }
    
    func setProvisioning() -> SettingsDictionary {
        merging(["PROVISIONING_PROFILE_SPECIFIER": SettingValue(stringLiteral: "$(APP_PROVISIONING_PROFILE)")])
            .merging(["PROVISIONING_PROFILE": SettingValue(stringLiteral: "$(APP_PROVISIONING_PROFILE)")])
    }
    
    
    func setAppInfo() -> SettingsDictionary {
        merging(["MARKETING_VERSION": SettingValue(stringLiteral: "1.0.0")])
            .merging(["CURRENT_PROJECT_VERSION": SettingValue(stringLiteral: "1")])
            .merging(["INFOPLIST_KEY_CFBundleDisplayName": SettingValue(stringLiteral: "Link")])
    }
}
