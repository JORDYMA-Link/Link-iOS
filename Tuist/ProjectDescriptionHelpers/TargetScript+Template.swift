//
//  TargetScript+extensions.swift
//  ProjectDescriptionHelpers
//
//  Created by kyuchul on 9/25/24.
//

import ProjectDescription

public extension TargetScript {
    static let firebaseCrashlytics: Self = .post(
        script: """
          if [ "${CONFIGURATION}" != "Debug" ]; then
            ROOT_DIR=
            "${SRCROOT%/*/*}/Tuist/.build/checkouts/firebase-ios-sdk/Crashlytics/run"
            echo "❗️ROOT_DIR Path: ${ROOT_DIR}"
          fi
          """,
        name: "Firebase Crashlytics",
        inputPaths: [
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}",
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Info.plist",
            "$(TARGET_BUILD_DIR)/$(UNLOCALIZED_RESOURCES_FOLDER_PATH)/GoogleService-Info.plist",
            "$(TARGET_BUILD_DIR)/$(EXECUTABLE_PATH)"
        ],
        basedOnDependencyAnalysis: false
    )
}
