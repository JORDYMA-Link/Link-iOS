//
//  Folder.swift
//  CoreKit
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation
import CommonFeature

public struct Folder: Identifiable, Equatable {
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

extension Folder: FolderItem {
  public var folderName: String {
    return self.name
  }
}

extension Folder {
  public static func makeFolderMock() -> [Folder] {
    return [
      .init(id: 23, name: "아르지닌6000", feedCount: 990),
      .init(id: 24, name: "아르지닌6000", feedCount: 990),
      .init(id: 25, name: "아르지닌6000", feedCount: 990)
    ]
  }
}
