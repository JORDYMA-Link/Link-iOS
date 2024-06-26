//
//  Folder.swift
//  CoreKit
//
//  Created by kyuchul on 6/20/24.
//  Copyright © 2024 com.kyuchul.blink. All rights reserved.
//

import Foundation

/// 서버 연결 이후 수정 예정
public struct Folder: Identifiable, Equatable {
  public var id = UUID().uuidString
  public var title: String
  public var count: Int
  
  public init(title: String, count: Int) {
    self.title = title
    self.count = count
  }
}

extension Folder {
  public static func makeFolderMock() -> [Folder] {
    return [
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990),
      .init(title: "아르지닌6000", count: 990)
    ]
  }
}
