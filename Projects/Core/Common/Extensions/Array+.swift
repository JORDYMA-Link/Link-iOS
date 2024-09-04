//
//  Array+.swift
//  Common
//
//  Created by kyuchul on 9/3/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public extension Array {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
