//
//  AppVersionResponse.swift
//  Models
//
//  Created by 문정호 on 9/2/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct AppVersionResponse: Decodable {
    public let results: [AppInfo]
}

public struct AppInfo: Decodable {
    public let version: String
}
