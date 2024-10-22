//
//  DomainFolder.swift
//  DomainFolderInterface
//
//  Created by kyuchul on 10/22/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

public struct DomainFolder: Identifiable, Equatable {
  public var id: Int
  public var name: String
  public var feedCount: Int
  
  public init(
    id: Int,
    name: String,
    feedCount: Int
  ) {
    self.id = id
    self.name = name
    self.feedCount = feedCount
  }
}
