//
//  LinkProcessing.swift
//  Services
//
//  Created by kyuchul on 8/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct LinkProcessing: Equatable {
  public let processingList: [LinkProcessingStatus]
  
  public init(processingList: [LinkProcessingStatus]) {
    self.processingList = processingList
  }
}
