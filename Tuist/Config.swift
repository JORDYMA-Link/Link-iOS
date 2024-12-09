//
//  Config.swift
//  Packages
//
//  Created by kyuchul on 9/29/24.
//

@preconcurrency import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToRoot("Plugins/DependencyPlugin"))
    ]
)
