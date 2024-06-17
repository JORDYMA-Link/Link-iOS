import ProjectDescription

public struct DefaultSetting {
    public static let DeploymentTargets: DeploymentTargets = .iOS("17.0")
    public static let organizationName = "kyuchul"
    public static let appIdentifier = "blink"
    public static let baseProductSetting: SettingsDictionary = SettingsDictionary()
        .debugInformationFormat(DebugInformationFormat.dwarfWithDsym)
        .otherLinkerFlags(["$(inherited) -ObjC"])
        .bitcodeEnabled(false)
}

public extension DefaultSetting {
    static func projectBundleId(isDev: Bool = false) -> String {
        if !isDev {
            return "com.\(organizationName).\(appIdentifier)"
        } else {
            return "com.\(organizationName).\(appIdentifier)-dev"
        }
    }
    static func bundleId(moduleName: String) -> String {
        return "com.\(organizationName).\(appIdentifier).\(moduleName)"
    }
}
