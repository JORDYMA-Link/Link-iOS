//
//  String+.swift
//  CommonFeature
//
//  Created by 문정호 on 5/6/24.
//  Copyright © 2024 jordyma. All rights reserved.
//

import Foundation

extension String {
    public var containsHTTPorHTTPS: Bool {
            return self.lowercased().hasPrefix("http") || self.lowercased().hasPrefix("https")
        }
}
